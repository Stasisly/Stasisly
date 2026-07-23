import 'dart:convert';
import 'dart:io';

const int _maximumParsedBodyBytes = 64 * 1024;
const int _maximumFieldNames = 20;
const int _maximumFieldNameLength = 64;
final RegExp _safeFieldName = RegExp(r'^[A-Za-z_][A-Za-z0-9_.-]{0,63}$');

final class SafeHttpDiagnostic {
  const SafeHttpDiagnostic({
    required this.operation,
    required this.statusCode,
    required this.statusClass,
    required this.contentTypeCategory,
    required this.bodyPresence,
    required this.bodySizeBucket,
    required this.jsonParseStatus,
    required this.topLevelFieldNames,
    required this.safeErrorCategory,
    required this.durationBucket,
    required this.assertionOutcome,
    required this.cleanupRequired,
    required this.diagnosticSanitization,
  });

  final String operation;
  final int statusCode;
  final String statusClass;
  final String contentTypeCategory;
  final String bodyPresence;
  final String bodySizeBucket;
  final String jsonParseStatus;
  final List<String> topLevelFieldNames;
  final String safeErrorCategory;
  final String durationBucket;
  final String assertionOutcome;
  final bool cleanupRequired;
  final String diagnosticSanitization;

  String toSafeBlock() {
    return [
      'SAFE_HTTP_DIAGNOSTIC_BEGIN',
      'operation=$operation',
      'statusCode=$statusCode',
      'statusClass=$statusClass',
      'contentTypeCategory=$contentTypeCategory',
      'bodyPresence=$bodyPresence',
      'bodySizeBucket=$bodySizeBucket',
      'jsonParseStatus=$jsonParseStatus',
      'topLevelFieldNames=${jsonEncode(topLevelFieldNames)}',
      'safeErrorCategory=$safeErrorCategory',
      'durationBucket=$durationBucket',
      'assertionOutcome=$assertionOutcome',
      'cleanupRequired=$cleanupRequired',
      'diagnosticSanitization=$diagnosticSanitization',
      'rawBodyLogged=false',
      'SAFE_HTTP_DIAGNOSTIC_END',
    ].join('\n');
  }
}

final class SafeHttpDiagnosticSanitizer {
  const SafeHttpDiagnosticSanitizer();

  SafeHttpDiagnostic sanitizeFile({
    required String operation,
    required String rawStatusCode,
    required String rawContentType,
    required String rawDurationSeconds,
    required String transportResult,
    required File bodyFile,
    required bool cleanupRequired,
  }) {
    SafeHttpDiagnostic diagnostic;
    try {
      final bodyLength = bodyFile.lengthSync();
      final bodyBytes = bodyLength <= _maximumParsedBodyBytes
          ? bodyFile.readAsBytesSync()
          : null;
      diagnostic = build(
        operation: operation,
        rawStatusCode: rawStatusCode,
        rawContentType: rawContentType,
        rawDurationSeconds: rawDurationSeconds,
        transportResult: transportResult,
        bodyLength: bodyLength,
        bodyBytes: bodyBytes,
        cleanupRequired: cleanupRequired,
      );
    } on Object {
      diagnostic = failedSanitization(
        operation: operation,
        rawStatusCode: rawStatusCode,
        rawContentType: rawContentType,
        rawDurationSeconds: rawDurationSeconds,
        transportResult: transportResult,
        cleanupRequired: cleanupRequired,
      );
    }

    try {
      if (bodyFile.existsSync()) {
        bodyFile.deleteSync();
      }
    } on Object {
      return failedSanitization(
        operation: operation,
        rawStatusCode: rawStatusCode,
        rawContentType: rawContentType,
        rawDurationSeconds: rawDurationSeconds,
        transportResult: transportResult,
        cleanupRequired: cleanupRequired,
      );
    }
    return diagnostic;
  }

  SafeHttpDiagnostic build({
    required String operation,
    required String rawStatusCode,
    required String rawContentType,
    required String rawDurationSeconds,
    required String transportResult,
    required int bodyLength,
    required List<int>? bodyBytes,
    required bool cleanupRequired,
  }) {
    final statusCode = _parseStatusCode(rawStatusCode);
    final contentType = _contentTypeCategory(rawContentType);
    final jsonShape = _jsonShape(
      contentType: contentType,
      bodyLength: bodyLength,
      bodyBytes: bodyBytes,
    );
    return SafeHttpDiagnostic(
      operation: operation == 'syntheticUserCreate'
          ? operation
          : 'unknownOperation',
      statusCode: statusCode,
      statusClass: _statusClass(statusCode),
      contentTypeCategory: contentType,
      bodyPresence: bodyLength == 0 ? 'empty' : 'present',
      bodySizeBucket: _bodySizeBucket(bodyLength),
      jsonParseStatus: jsonShape.status,
      topLevelFieldNames: jsonShape.fieldNames,
      safeErrorCategory: _safeErrorCategory(
        statusCode: statusCode,
        contentType: contentType,
        jsonParseStatus: jsonShape.status,
        transportResult: transportResult,
      ),
      durationBucket: _durationBucket(rawDurationSeconds),
      assertionOutcome: transportResult == 'ok' && statusCode == 200
          ? 'passed'
          : 'failed',
      cleanupRequired: cleanupRequired,
      diagnosticSanitization: 'passed',
    );
  }

  SafeHttpDiagnostic failedSanitization({
    required String operation,
    required String rawStatusCode,
    required String rawContentType,
    required String rawDurationSeconds,
    required String transportResult,
    required bool cleanupRequired,
  }) {
    final statusCode = _parseStatusCode(rawStatusCode);
    return SafeHttpDiagnostic(
      operation: operation == 'syntheticUserCreate'
          ? operation
          : 'unknownOperation',
      statusCode: statusCode,
      statusClass: _statusClass(statusCode),
      contentTypeCategory: _contentTypeCategory(rawContentType),
      bodyPresence: 'empty',
      bodySizeBucket: '0',
      jsonParseStatus: 'notAttempted',
      topLevelFieldNames: const [],
      safeErrorCategory: transportResult == 'timeout'
          ? 'timeout'
          : transportResult == 'failure'
          ? 'transportFailure'
          : 'unknownFailure',
      durationBucket: _durationBucket(rawDurationSeconds),
      assertionOutcome: 'failed',
      cleanupRequired: cleanupRequired,
      diagnosticSanitization: 'failed',
    );
  }
}

final class _JsonShape {
  const _JsonShape(this.status, this.fieldNames);

  final String status;
  final List<String> fieldNames;
}

int _parseStatusCode(String raw) {
  final value = int.tryParse(raw.trim());
  return value != null && value >= 100 && value <= 599 ? value : 0;
}

String _statusClass(int statusCode) {
  if (statusCode >= 100 && statusCode <= 199) return 'informational';
  if (statusCode >= 200 && statusCode <= 299) return 'success';
  if (statusCode >= 300 && statusCode <= 399) return 'redirect';
  if (statusCode >= 400 && statusCode <= 499) return 'clientError';
  if (statusCode >= 500 && statusCode <= 599) return 'serverError';
  return 'invalidStatus';
}

String _contentTypeCategory(String raw) {
  final value = raw.trim().toLowerCase().split(';').first.trim();
  if (value.isEmpty) return 'empty';
  if (value == 'application/problem+json') return 'problemJson';
  if (value == 'application/json' || value.endsWith('+json')) return 'json';
  if (value == 'text/html') return 'html';
  if (value.startsWith('text/')) return 'text';
  if (value.startsWith('image/') ||
      value.startsWith('audio/') ||
      value.startsWith('video/') ||
      value == 'application/octet-stream') {
    return 'binary';
  }
  return 'unknown';
}

String _bodySizeBucket(int length) {
  if (length <= 0) return '0';
  if (length <= 255) return '1to255';
  if (length <= 1023) return '256to1023';
  if (length <= 4096) return '1kto4k';
  return 'over4k';
}

_JsonShape _jsonShape({
  required String contentType,
  required int bodyLength,
  required List<int>? bodyBytes,
}) {
  if (bodyLength == 0 ||
      (contentType != 'json' && contentType != 'problemJson') ||
      bodyBytes == null) {
    return const _JsonShape('notAttempted', []);
  }
  try {
    final decoded = jsonDecode(utf8.decode(bodyBytes));
    if (decoded is Map) {
      final names =
          decoded.keys
              .map((key) => _sanitizeFieldName(key.toString()))
              .toSet()
              .toList()
            ..sort();
      return _JsonShape(
        'validObject',
        List.unmodifiable(names.take(_maximumFieldNames)),
      );
    }
    if (decoded is List) return const _JsonShape('validArray', []);
    return const _JsonShape('validScalar', []);
  } on Object {
    return const _JsonShape('invalid', []);
  }
}

String _sanitizeFieldName(String value) {
  if (value.length > _maximumFieldNameLength ||
      !_safeFieldName.hasMatch(value)) {
    return 'REDACTED_FIELD_NAME';
  }
  return value;
}

String _safeErrorCategory({
  required int statusCode,
  required String contentType,
  required String jsonParseStatus,
  required String transportResult,
}) {
  if (transportResult == 'timeout') return 'timeout';
  if (transportResult != 'ok') return 'transportFailure';
  if (statusCode == 401) return 'authenticationRejected';
  if (statusCode == 403) return 'authorizationRejected';
  if (statusCode == 400 || statusCode == 422) return 'validationRejected';
  if (statusCode == 409) return 'conflict';
  if (statusCode == 429) return 'rateLimited';
  if (statusCode >= 500 && statusCode <= 599) return 'backendUnavailable';
  if ((contentType == 'json' || contentType == 'problemJson') &&
      jsonParseStatus == 'invalid') {
    return 'invalidJson';
  }
  if (statusCode == 200) return 'none';
  if (statusCode == 0) return 'unknownFailure';
  return 'unexpectedResponse';
}

String _durationBucket(String rawSeconds) {
  final seconds = double.tryParse(rawSeconds.trim());
  if (seconds == null || seconds.isNegative || !seconds.isFinite) {
    return 'over10s';
  }
  final milliseconds = seconds * 1000;
  if (milliseconds < 100) return 'under100ms';
  if (milliseconds < 300) return '100to300ms';
  if (milliseconds < 1000) return '300to1000ms';
  if (milliseconds < 3000) return '1to3s';
  if (milliseconds < 10000) return '3to10s';
  return 'over10s';
}

void main(List<String> arguments) {
  final options = _parseOptions(arguments);
  final bodyPath = options['body-file'];
  if (bodyPath == null) {
    stderr.writeln('Safe diagnostic input invalid.');
    exitCode = 64;
    return;
  }
  const sanitizer = SafeHttpDiagnosticSanitizer();
  final diagnostic = sanitizer.sanitizeFile(
    operation: options['operation'] ?? '',
    rawStatusCode: options['status-code'] ?? '',
    rawContentType: options['content-type'] ?? '',
    rawDurationSeconds: options['duration-seconds'] ?? '',
    transportResult: options['transport-result'] ?? 'failure',
    bodyFile: File(bodyPath),
    cleanupRequired: options['cleanup-required'] == 'true',
  );
  stdout.writeln(diagnostic.toSafeBlock());
  if (diagnostic.diagnosticSanitization != 'passed') {
    exitCode = 1;
  }
}

Map<String, String> _parseOptions(List<String> arguments) {
  final result = <String, String>{};
  for (var index = 0; index < arguments.length; index += 2) {
    if (index + 1 >= arguments.length || !arguments[index].startsWith('--')) {
      return const {};
    }
    result[arguments[index].substring(2)] = arguments[index + 1];
  }
  return result;
}
