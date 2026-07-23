import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/safe_http_diagnostic.dart';

const _canaries = <String>[
  'FAKE_TOKEN_DO_NOT_LOG',
  'FAKE_SERVICE_ROLE_DO_NOT_LOG',
  'FAKE_EMAIL_DO_NOT_LOG',
  'FAKE_PASSWORD_DO_NOT_LOG',
  'FAKE_PROJECT_REF_DO_NOT_LOG',
];

void main() {
  const sanitizer = SafeHttpDiagnosticSanitizer();

  group('closed HTTP diagnostic classifications', () {
    final cases = <_Case>[
      const _Case(
        200,
        'application/json',
        '{"id":"secret"}',
        'none',
        assertionPasses: true,
      ),
      const _Case(
        200,
        'application/json',
        '{"id":"secret"}',
        'none',
        assertionPasses: true,
      ),
      const _Case(
        201,
        'application/json',
        '{"id":"secret"}',
        'unexpectedResponse',
        assertionPasses: false,
      ),
      const _Case(
        201,
        'application/json',
        '{"id":"secret"}',
        'unexpectedResponse',
        assertionPasses: false,
      ),
      const _Case(204, '', '', 'unexpectedResponse', assertionPasses: false),
      const _Case(
        400,
        'application/problem+json',
        '{"title":"secret"}',
        'validationRejected',
        assertionPasses: false,
      ),
      const _Case(
        401,
        'application/json',
        '{"message":"secret"}',
        'authenticationRejected',
        assertionPasses: false,
      ),
      const _Case(
        403,
        'application/json',
        '{"message":"secret"}',
        'authorizationRejected',
        assertionPasses: false,
      ),
      const _Case(
        409,
        'application/json',
        '{"message":"secret"}',
        'conflict',
        assertionPasses: false,
      ),
      const _Case(
        429,
        'application/json',
        '{"message":"secret"}',
        'rateLimited',
        assertionPasses: false,
      ),
      const _Case(
        500,
        'text/html; charset=utf-8',
        '<html>secret</html>',
        'backendUnavailable',
        assertionPasses: false,
      ),
      const _Case(
        200,
        'application/json',
        '{invalid',
        'invalidJson',
        assertionPasses: true,
      ),
    ];

    for (final entry in cases) {
      test('${entry.status} ${entry.contentType} ${entry.body.length}', () {
        final diagnostic = sanitizer.build(
          operation: 'syntheticUserCreate',
          rawStatusCode: '${entry.status}',
          rawContentType: entry.contentType,
          rawDurationSeconds: '0.250',
          transportResult: 'ok',
          bodyLength: utf8.encode(entry.body).length,
          bodyBytes: utf8.encode(entry.body),
          cleanupRequired: true,
        );
        expect(diagnostic.safeErrorCategory, entry.errorCategory);
        expect(
          diagnostic.assertionOutcome,
          entry.assertionPasses ? 'passed' : 'failed',
        );
        expect(diagnostic.cleanupRequired, isTrue);
        expect(diagnostic.toSafeBlock(), isNot(contains('secret')));
      });
    }
  });

  test('body, JSON shape and content type use only closed categories', () {
    final empty = _build(body: '', contentType: '');
    expect(empty.bodyPresence, 'empty');
    expect(empty.bodySizeBucket, '0');
    expect(empty.jsonParseStatus, 'notAttempted');
    expect(empty.contentTypeCategory, 'empty');

    final array = _build(body: '["secret"]');
    expect(array.jsonParseStatus, 'validArray');
    expect(array.topLevelFieldNames, isEmpty);

    final scalar = _build(body: '"secret"');
    expect(scalar.jsonParseStatus, 'validScalar');
    expect(scalar.topLevelFieldNames, isEmpty);

    final binary = _build(
      body: 'secret',
      contentType: 'application/octet-stream',
    );
    expect(binary.contentTypeCategory, 'binary');
    expect(binary.jsonParseStatus, 'notAttempted');
  });

  test('size and duration buckets cover their closed ranges', () {
    expect(_buildWithLength(0).bodySizeBucket, '0');
    expect(_buildWithLength(1).bodySizeBucket, '1to255');
    expect(_buildWithLength(256).bodySizeBucket, '256to1023');
    expect(_buildWithLength(1024).bodySizeBucket, '1kto4k');
    expect(_buildWithLength(4097).bodySizeBucket, 'over4k');

    for (final pair in <(String, String)>[
      ('0.050', 'under100ms'),
      ('0.100', '100to300ms'),
      ('0.300', '300to1000ms'),
      ('1.000', '1to3s'),
      ('3.000', '3to10s'),
      ('10.000', 'over10s'),
    ]) {
      expect(_build(duration: pair.$1).durationBucket, pair.$2);
    }
  });

  test('field names are sorted, bounded, deduplicated and sanitized', () {
    final values = <String, Object?>{
      'zeta': 'hidden',
      'alpha': {'nestedSecret': _canaries.first},
      'bad\nname': 'hidden',
      'unicode_\u00f1': 'hidden',
      'x' * 65: 'hidden',
      for (var index = 0; index < 25; index++) 'field_$index': 'hidden',
    };
    final diagnostic = _build(body: jsonEncode(values));
    expect(diagnostic.jsonParseStatus, 'validObject');
    expect(diagnostic.topLevelFieldNames, hasLength(20));
    expect(
      diagnostic.topLevelFieldNames,
      orderedEquals([...diagnostic.topLevelFieldNames]..sort()),
    );
    expect(diagnostic.topLevelFieldNames, contains('REDACTED_FIELD_NAME'));
    expect(diagnostic.toSafeBlock(), isNot(contains('nestedSecret')));
  });

  test('synthetic canary values never enter output', () {
    final body = jsonEncode({
      'token': _canaries[0],
      'serviceRole': _canaries[1],
      'email': _canaries[2],
      'password': _canaries[3],
      'projectRef': _canaries[4],
      'nested': {'authorization': 'Bearer ${_canaries[0]}'},
      'url': 'https://development.invalid/private',
    });
    final output = _build(body: body).toSafeBlock();
    for (final canary in _canaries) {
      expect(output, isNot(contains(canary)));
    }
    expect(output, isNot(contains('Bearer ')));
    expect(output, isNot(contains('https://')));
    expect(output, isNot(contains('development.invalid')));
  });

  test('transport failure and timeout fail the exact assertion', () {
    final failure = _build(status: '0', transport: 'failure');
    expect(failure.safeErrorCategory, 'transportFailure');
    expect(failure.assertionOutcome, 'failed');

    final timeout = _build(status: '0', transport: 'timeout');
    expect(timeout.safeErrorCategory, 'timeout');
    expect(timeout.assertionOutcome, 'failed');
  });

  test('oversized body is categorized without parsing content', () {
    final diagnostic = sanitizer.build(
      operation: 'syntheticUserCreate',
      rawStatusCode: '500',
      rawContentType: 'application/json',
      rawDurationSeconds: '0.1',
      transportResult: 'ok',
      bodyLength: 65 * 1024,
      bodyBytes: null,
      cleanupRequired: true,
    );
    expect(diagnostic.bodySizeBucket, 'over4k');
    expect(diagnostic.jsonParseStatus, 'notAttempted');
    expect(diagnostic.topLevelFieldNames, isEmpty);
  });

  test('temporary body is deleted after successful sanitization', () {
    final directory = Directory.systemTemp.createTempSync('safe-http-');
    addTearDown(() => directory.deleteSync(recursive: true));
    final body = File('${directory.path}/body.json')
      ..writeAsStringSync('{"id":"${_canaries.first}"}');

    final diagnostic = sanitizer.sanitizeFile(
      operation: 'syntheticUserCreate',
      rawStatusCode: '200',
      rawContentType: 'application/json',
      rawDurationSeconds: '0.1',
      transportResult: 'ok',
      bodyFile: body,
      cleanupRequired: true,
    );

    expect(diagnostic.diagnosticSanitization, 'passed');
    expect(body.existsSync(), isFalse);
    expect(diagnostic.toSafeBlock(), isNot(contains(_canaries.first)));
  });

  test('sanitizer failure is closed and contains no input path', () {
    final missing = File(
      '${Directory.systemTemp.path}/'
      'FAKE_TOKEN_DO_NOT_LOG-does-not-exist/body.json',
    );
    final diagnostic = sanitizer.sanitizeFile(
      operation: 'syntheticUserCreate',
      rawStatusCode: '200',
      rawContentType: 'application/json',
      rawDurationSeconds: '0.1',
      transportResult: 'ok',
      bodyFile: missing,
      cleanupRequired: true,
    );
    final output = diagnostic.toSafeBlock();
    expect(diagnostic.diagnosticSanitization, 'failed');
    expect(diagnostic.safeErrorCategory, 'unknownFailure');
    expect(diagnostic.assertionOutcome, 'failed');
    expect(output, isNot(contains(_canaries.first)));
    expect(output, contains('rawBodyLogged=false'));
  });
}

SafeHttpDiagnostic _build({
  String status = '200',
  String contentType = 'application/json',
  String body = '{"id":"hidden"}',
  String duration = '0.1',
  String transport = 'ok',
}) {
  final bytes = utf8.encode(body);
  return const SafeHttpDiagnosticSanitizer().build(
    operation: 'syntheticUserCreate',
    rawStatusCode: status,
    rawContentType: contentType,
    rawDurationSeconds: duration,
    transportResult: transport,
    bodyLength: bytes.length,
    bodyBytes: bytes,
    cleanupRequired: true,
  );
}

SafeHttpDiagnostic _buildWithLength(int length) {
  return const SafeHttpDiagnosticSanitizer().build(
    operation: 'syntheticUserCreate',
    rawStatusCode: '200',
    rawContentType: 'text/plain',
    rawDurationSeconds: '0.1',
    transportResult: 'ok',
    bodyLength: length,
    bodyBytes: null,
    cleanupRequired: true,
  );
}

final class _Case {
  const _Case(
    this.status,
    this.contentType,
    this.body,
    this.errorCategory, {
    required this.assertionPasses,
  });

  final int status;
  final String contentType;
  final String body;
  final String errorCategory;
  final bool assertionPasses;
}
