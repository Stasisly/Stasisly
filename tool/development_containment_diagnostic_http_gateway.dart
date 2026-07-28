import 'dart:convert';
import 'dart:io';

import 'development_containment_diagnostic_contracts.dart';

final class _DiagnosticHttpResult {
  const _DiagnosticHttpResult(this.statusCode, this.body);

  final int statusCode;
  final Object? body;
}

final class HttpContainmentDiagnosticGateway
    implements ContainmentDiagnosticGateway {
  HttpContainmentDiagnosticGateway({
    required this.baseUrl,
    required this.serviceRoleKey,
    required this.failedRunAlias,
    required this.exactExpectedOwnerId,
  });

  final Uri baseUrl;
  final String serviceRoleKey;
  final String failedRunAlias;
  final String exactExpectedOwnerId;

  String get _derivedProfileMarker => 'Synthetic $failedRunAlias';

  String _profileDeleteHandle = '';

  @override
  Future<CatalogDiagnosticObservation> diagnoseCatalog() async {
    try {
      final result = await _request(
        method: 'GET',
        uri: _endpoint('/rest/v1/specialist_catalog', {
          'select':
              'product_area,is_published,publication_status,'
              'availability_status,supported_surfaces,is_conversable,access_tier',
          'product_area': 'eq.stasis',
          'order': 'sort_order.asc,id.asc',
          'limit': '20',
        }),
      );
      if (result.statusCode < 200 || result.statusCode >= 300) {
        return CatalogDiagnosticObservation(httpStatus: result.statusCode);
      }
      final body = result.body;
      if (body is! List<Object?>) {
        return const CatalogDiagnosticObservation(contractValid: false);
      }
      if (body.length >= 20) {
        return const CatalogDiagnosticObservation(pageLimitReached: true);
      }
      final candidates = <CatalogCandidateObservation>[];
      for (final value in body) {
        if (value is! Map) {
          return const CatalogDiagnosticObservation(contractValid: false);
        }
        final row = Map<String, Object?>.from(value);
        const expectedKeys = {
          'access_tier',
          'availability_status',
          'is_conversable',
          'is_published',
          'product_area',
          'publication_status',
          'supported_surfaces',
        };
        if (row.keys.toSet().difference(expectedKeys).isNotEmpty ||
            expectedKeys.difference(row.keys.toSet()).isNotEmpty) {
          return const CatalogDiagnosticObservation(contractValid: false);
        }
        final area = row['product_area'];
        final publication = row['publication_status'];
        final availability = row['availability_status'];
        final surfaces = row['supported_surfaces'];
        final accessTier = row['access_tier'];
        final statusValid =
            area == 'stasis' &&
            publication is String &&
            const {
              'draft',
              'review',
              'published',
              'unpublished',
              'disabled',
              'maintenance',
            }.contains(publication) &&
            availability is String &&
            const {
              'available',
              'limited',
              'unavailable',
              'coming_soon',
            }.contains(availability) &&
            accessTier is String &&
            const {'free', 'pro', 'vip'}.contains(accessTier);
        candidates.add(
          CatalogCandidateObservation(
            statusValid: statusValid,
            selectable:
                row['is_published'] == true &&
                publication == 'published' &&
                row['is_conversable'] == true,
            productAvailable:
                availability == 'available' &&
                surfaces is List &&
                surfaces.length == 1 &&
                surfaces.single == 'product',
            environmentCompatible: true,
          ),
        );
      }
      return CatalogDiagnosticObservation(candidates: candidates);
    } on FormatException {
      return const CatalogDiagnosticObservation(jsonDecoded: false);
    } on Object {
      return const CatalogDiagnosticObservation(transportSucceeded: false);
    }
  }

  @override
  Future<List<CounterEvidence>> readSevenCounters() async {
    final profile = await _readProfileCounter();
    return [
      _evidenceZero('messages', 'MESSAGE_REQUEST_NOT_SENT'),
      _evidenceZero('idempotency', 'IDEMPOTENCY_REQUEST_NOT_SENT'),
      _evidenceZero('sessions', 'CONVERSATION_REQUEST_NOT_SENT'),
      profile,
      _canonicalZero('catalog'),
      _canonicalZero('specialists'),
      _evidenceZero('auth', 'PRIOR_EXACT_POST_LOOKUP_ABSENT'),
    ];
  }

  @override
  Future<bool> containExact(List<ContainmentOperation> operations) async {
    if (operations.length != 1 ||
        operations.single.resourceName != 'profiles' ||
        _profileDeleteHandle.isEmpty ||
        exactExpectedOwnerId.isEmpty ||
        _profileDeleteHandle != exactExpectedOwnerId) {
      return false;
    }
    final result = await _request(
      method: 'DELETE',
      uri: _endpoint('/rest/v1/users', {'id': 'eq.$_profileDeleteHandle'}),
    );
    return exactContainmentDeleteSucceeded(result.statusCode);
  }

  @override
  Future<bool> isolateCli() async {
    try {
      for (final path in [
        'supabase/.temp/project-ref',
        'supabase/.temp/pooler-url',
      ]) {
        final file = File(path);
        if (file.existsSync()) file.deleteSync();
      }
      final result = await Process.run(Platform.resolvedExecutable, [
        'run',
        'tool/check_supabase_remote_context.dart',
      ]);
      return result.exitCode == 0;
    } on Object {
      return false;
    }
  }

  Future<CounterEvidence> _readProfileCounter() async {
    try {
      final result = await _request(
        method: 'GET',
        uri: _endpoint('/rest/v1/users', {
          'select': 'id,display_name',
          'display_name': 'eq.$_derivedProfileMarker',
          'limit': '2',
        }),
      );
      if (result.statusCode != 200) {
        return _counterFailure(CounterResultCategory.queryFailed);
      }
      final body = result.body;
      if (body is! List<Object?> || body.length > 2) {
        return _counterFailure(CounterResultCategory.unknownBlocking);
      }
      if (body.isEmpty) {
        _profileDeleteHandle = '';
        return const CounterEvidence(
          name: 'profiles',
          result: CounterResultCategory.zero,
          count: 0,
          lookupExact: true,
          queryBound: 2,
          ownership: ResourceOwnership.createdByFailedRun,
        );
      }
      if (body.length != 1) {
        return _counterFailure(CounterResultCategory.unknownBlocking);
      }
      final single = body.single;
      if (single is! Map) {
        return _counterFailure(CounterResultCategory.unknownBlocking);
      }
      final row = Map<String, Object?>.from(single);
      final id = row['id'];
      if (row.length != 2 ||
          id is! String ||
          !_uuidPattern.hasMatch(id) ||
          row['display_name'] != _derivedProfileMarker) {
        return _counterFailure(CounterResultCategory.unknownBlocking);
      }
      final exactProof =
          exactExpectedOwnerId.isNotEmpty && id == exactExpectedOwnerId;
      _profileDeleteHandle = exactProof ? id : '';
      return CounterEvidence(
        name: 'profiles',
        result: CounterResultCategory.nonzeroExact,
        count: 1,
        lookupExact: true,
        queryBound: 2,
        ownership: exactProof
            ? ResourceOwnership.createdByFailedRun
            : ResourceOwnership.unknownOwnership,
        exactOwnershipProof: exactProof,
        exactDeleteHandle: exactProof,
      );
    } on FormatException {
      return _counterFailure(CounterResultCategory.unknownBlocking);
    } on Object {
      return _counterFailure(CounterResultCategory.queryFailed);
    }
  }

  CounterEvidence _counterFailure(CounterResultCategory result) =>
      CounterEvidence(
        name: 'profiles',
        result: result,
        count: null,
        lookupExact: true,
        queryBound: 2,
        ownership: ResourceOwnership.unknownOwnership,
      );

  CounterEvidence _evidenceZero(String name, String proof) {
    if (proof.isEmpty) throw StateError('COUNTER_PROOF_REQUIRED');
    return CounterEvidence(
      name: name,
      result: CounterResultCategory.zero,
      count: 0,
      lookupExact: true,
      queryBound: 0,
      ownership: ResourceOwnership.createdByFailedRun,
    );
  }

  CounterEvidence _canonicalZero(String name) => CounterEvidence(
    name: name,
    result: CounterResultCategory.zero,
    count: 0,
    lookupExact: true,
    queryBound: 0,
    ownership: ResourceOwnership.verifiedPreexistingReadOnly,
  );

  Uri _endpoint(String path, Map<String, String> query) =>
      baseUrl.resolve(path).replace(queryParameters: query);

  Future<_DiagnosticHttpResult> _request({
    required String method,
    required Uri uri,
  }) async {
    if (method != 'GET' && method != 'DELETE') {
      throw StateError('DIAGNOSTIC_HTTP_METHOD_BLOCKED');
    }
    if (uri.host != baseUrl.host || uri.scheme != 'https') {
      throw StateError('DIAGNOSTIC_TARGET_BLOCKED');
    }
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client.openUrl(method, uri);
      request
        ..followRedirects = false
        ..maxRedirects = 0;
      request.headers
        ..set('apikey', serviceRoleKey)
        ..set(HttpHeaders.authorizationHeader, 'Bearer $serviceRoleKey')
        ..set(HttpHeaders.acceptHeader, 'application/json');
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      final raw = await response.transform(utf8.decoder).join();
      final body = raw.trim().isEmpty ? null : jsonDecode(raw);
      return _DiagnosticHttpResult(response.statusCode, body);
    } finally {
      client.close(force: true);
    }
  }
}

final _uuidPattern = RegExp(
  r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
  caseSensitive: false,
);
