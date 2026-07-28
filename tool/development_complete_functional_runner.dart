import 'dart:convert';
import 'dart:io';

import 'development_catalog_envelope_adapter.dart';
import 'development_complete_runner_contracts.dart';

const _manifestPath =
    'docs/stasisly_foundation/development/'
    'development_second_functional_attempt_manifest.json';

final class _HttpResult {
  const _HttpResult(this.status, this.body, {this.location});

  final int status;
  final Object? body;
  final String? location;
}

final class _RemoteClient {
  _RemoteClient({
    required this.baseUrl,
    required this.anonKey,
    required this.serviceRoleKey,
  });

  final Uri baseUrl;
  final String anonKey;
  final String serviceRoleKey;

  Future<_HttpResult> request({
    required String method,
    required Uri uri,
    String? token,
    Object? body,
    Map<String, String> headers = const {},
    bool followRedirects = false,
  }) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 15);
    try {
      final request = await client.openUrl(method, uri);
      request
        ..followRedirects = followRedirects
        ..maxRedirects = 0;
      if (uri.host == baseUrl.host) {
        request.headers.set('apikey', token == null ? serviceRoleKey : anonKey);
        request.headers.set(
          HttpHeaders.authorizationHeader,
          'Bearer ${token ?? serviceRoleKey}',
        );
      }
      for (final entry in headers.entries) {
        request.headers.set(entry.key, entry.value);
      }
      if (body != null) {
        request.headers.contentType = ContentType.json;
        request.write(jsonEncode(body));
      }
      final response = await request.close().timeout(
        const Duration(seconds: 30),
      );
      final raw = await response.transform(utf8.decoder).join();
      Object? decoded;
      if (raw.trim().isNotEmpty) {
        try {
          decoded = jsonDecode(raw);
        } on FormatException {
          decoded = null;
        }
      }
      return _HttpResult(
        response.statusCode,
        decoded,
        location: response.headers.value(HttpHeaders.locationHeader),
      );
    } finally {
      client.close(force: true);
    }
  }

  Uri endpoint(String path, [Map<String, String>? query]) =>
      baseUrl.resolve(path).replace(queryParameters: query);
}

final class _RunContext {
  _RunContext(this.environment)
    : baseUrl = Uri.parse(environment['SUPABASE_URL'] ?? ''),
      productOrigin = Uri.parse(
        environment['DEVELOPMENT_ALLOWED_WEB_ORIGIN'] ?? '',
      ),
      alias = environment['REMOTE_FIXTURE_RUN_ALIAS'] ?? '',
      projectRef = environment['SUPABASE_PROJECT_REF'] ?? '';

  final Map<String, String> environment;
  final Uri baseUrl;
  final Uri productOrigin;
  final String alias;
  final String projectRef;

  late final String ownerEmail = _syntheticEmail('$alias-owner');
  late final String foreignEmail = _syntheticEmail('$alias-foreign');
  late final String password = 'Synthetic-$alias-Aa9!';
  late final String displayName = 'Synthetic $alias';
  late final String createAttempt = '${alias}_create_0001';
  late final String messageAttempt = '${alias}_send_000001';
  late final String messageContent = 'synthetic bounded message';

  String ownerId = '';
  String foreignId = '';
  String ownerToken = '';
  String foreignToken = '';
  String selectableSpecialistId = '';
  String conversationId = '';
  String messageId = '';
}

final class _FunctionalExecution {
  _FunctionalExecution({
    required this.context,
    required this.manifest,
    required this.client,
  }) : state = CompleteRunnerStateMachine(manifest),
       ledger = CompleteResourceLedger();

  final _RunContext context;
  final CompleteRunnerManifest manifest;
  final _RemoteClient client;
  final CompleteRunnerStateMachine state;
  final CompleteResourceLedger ledger;

  bool flowPassed = false;
  bool cleanupPassed = false;
  bool authAbsent = false;
  bool evidenceSafe = true;
  bool cliIsolated = false;
  List<int>? counters;

  void _advance(String next, String evidence) {
    state.advance(next, evidence: evidence);
    stdout.writeln('state=$next');
  }

  Future<void> run() async {
    try {
      validatePreflight();
      verifyTarget();
      startSetup();
      await createOwnerPrincipal();
      await resolveSpecialistFromCanonicalCatalog();
      await createConversation();
      await validateReplayStage();
      await validateActiveList();
      await validateDetail();
      await sendUserMessage();
      await validateNoAi();
      await archiveConversation();
      await validateArchivedState();
      await restoreConversation();
      await validateRestoredState();
      await validateForeignOpacity();
      await validateBlockedRoutes();
      completeFlow();
      flowPassed = true;
    } on Object {
      flowPassed = false;
    } finally {
      await _finish();
    }
  }

  void validatePreflight() {
    final findings = manifest.validate();
    if (findings.isNotEmpty) throw StateError('RUNNER_PREFLIGHT_BLOCKED');
    const exact = {
      'APP_MODE': 'development',
      'BACKEND_TARGET_ENVIRONMENT': 'development',
      'REMOTE_RUNNER_EXECUTION_MODE': 'second-functional-attempt',
      'SECOND_FUNCTIONAL_ATTEMPT_AUTHORIZATION_STATUS': 'GRANTED_AT_RUNTIME',
      'SECOND_FUNCTIONAL_ATTEMPT_MANIFEST_VERSION': completeManifestVersion,
      'REMOTE_RUNNER_VERSION': completeRunnerVersion,
      'ENABLE_REMOTE_BACKEND': 'true',
      'ENABLE_REAL_AUTH': 'true',
      'ENABLE_REAL_DATA': 'false',
      'ALLOW_DEV_ROUTES': 'true',
      'ENABLE_CONVERSATIONS_ROUTE': 'false',
    };
    for (final entry in exact.entries) {
      if (context.environment[entry.key] != entry.value) {
        throw StateError('RUNNER_PREFLIGHT_BLOCKED');
      }
    }
    for (final key in [
      'FOUNDER_AUTHORIZATION_REFERENCE',
      'AUTHORIZED_COMMIT_SHA',
      'SUPABASE_PROJECT_REF',
      'DEVELOPMENT_OPERATOR',
      'DEVELOPMENT_ALLOWED_WEB_ORIGIN',
    ]) {
      if ((context.environment[key] ?? '').trim().isEmpty) {
        throw StateError('RUNNER_PREFLIGHT_BLOCKED');
      }
    }
    _advance('PREFLIGHT_VALIDATED', 'PREFLIGHT_VALIDATED');
  }

  void verifyTarget() {
    if (context.baseUrl.scheme != 'https' ||
        context.baseUrl.host != '${context.projectRef}.supabase.co' ||
        context.productOrigin.scheme != 'https' ||
        context.productOrigin.host.isEmpty) {
      throw StateError('REMOTE_TARGET_MISMATCH');
    }
    _advance('TARGET_VERIFIED', 'REMOTE_TARGET_VERIFIED_DEVELOPMENT');
  }

  void startSetup() {
    if (!RegExp(r'^[a-z0-9][a-z0-9-]{7,31}$').hasMatch(context.alias)) {
      throw StateError('SETUP_BLOCKED');
    }
    _advance('SETUP_STARTED', 'SETUP_STARTED');
  }

  Future<void> createOwnerPrincipal() async {
    final result = await client.request(
      method: 'POST',
      uri: client.endpoint('/auth/v1/admin/users'),
      body: {
        'email': context.ownerEmail,
        'password': context.password,
        'email_confirm': true,
      },
    );
    await _emitSafeAuthDiagnostic(result);
    if (result.status != 200) throw StateError('AUTH_SETUP_FAILED');
    context.ownerId = _requiredUuid(_object(result.body)['id']);
    ledger.register(
      LedgerEntry(
        category: ResourceCategory.ownerAuth,
        disposition: ResourceDisposition.createdByRun,
        creationState: 'AUTH_USER_CREATED',
        ownershipProof: context.alias,
        cleanupHandle: context.ownerId,
        cleanupRequired: true,
      ),
    );
    _advance('AUTH_USER_CREATED', 'AUTH_USER_CREATED');
  }

  Future<void> resolveSpecialistFromCanonicalCatalog() async {
    await _createProfile(context.ownerId);
    context.ownerToken = await _login(context.ownerEmail);
    final result = await client.request(
      method: 'GET',
      uri: client.endpoint('/functions/v1/list-selectable-specialists', {
        'area': 'stasis',
      }),
      token: context.ownerToken,
    );
    final resolution = const VerifiedPreexistingReadOnlyPolicy().resolve(
      catalogPayload: result.body,
      sourceCategory: CatalogEnvelopeSourceCategory.productItemsEnvelope,
      catalogAvailable: result.status == 200,
      environment: context.environment['APP_MODE'] ?? '',
      policyAuthorized:
          manifest.specialistPolicy == canonicalSpecialistPolicy &&
          manifest.specialistSource == canonicalSpecialistSource &&
          manifest.specialistSelectionMode == canonicalSpecialistSelectionMode,
    );
    if (!resolution.mayContinue) {
      throw StateError('SPECIALIST_RESOLUTION_FAILED');
    }
    context.selectableSpecialistId =
        resolution.specialist!.selectableSpecialistId;
    for (final category in [
      ResourceCategory.catalog,
      ResourceCategory.specialist,
    ]) {
      ledger
        ..register(
          LedgerEntry(
            category: category,
            disposition: ResourceDisposition.verifiedPreexistingReadOnly,
            creationState: 'SPECIALIST_RESOLVED',
            ownershipProof: canonicalSpecialistSource,
            cleanupHandle: '',
            cleanupRequired: false,
          ),
        )
        ..markVerified(category);
    }
    _advance('SPECIALIST_RESOLVED', 'SPECIALIST_RESOLVED');
  }

  Future<void> _createProfile(String ownerId) async {
    final profile = await client.request(
      method: 'POST',
      uri: client.endpoint('/rest/v1/users'),
      headers: {'Prefer': 'return=minimal'},
      body: {'id': ownerId, 'display_name': context.displayName},
    );
    if (profile.status != 201) throw StateError('AUTH_SETUP_FAILED');
    ledger.register(
      LedgerEntry(
        category: ResourceCategory.profile,
        disposition: ResourceDisposition.createdByRun,
        creationState: 'AUTH_USER_CREATED',
        ownershipProof: context.alias,
        cleanupHandle: ownerId,
        cleanupRequired: true,
      ),
    );
  }

  Future<String> _login(String email) async {
    final result = await client.request(
      method: 'POST',
      uri: client.endpoint('/auth/v1/token', {'grant_type': 'password'}),
      token: client.anonKey,
      body: {'email': email, 'password': context.password},
    );
    if (result.status != 200) throw StateError('AUTH_SETUP_FAILED');
    final token = _object(result.body)['access_token'];
    if (token is! String || token.isEmpty) {
      throw StateError('AUTH_SETUP_FAILED');
    }
    return token;
  }

  Future<void> createConversation() async {
    late final _HttpResult first;
    try {
      first = await _createConversationRequest();
    } on Object {
      first = await _createConversationRequest();
    }
    if (first.status != 200 && first.status != 201) {
      throw StateError('CONVERSATION_CREATE_FAILED');
    }
    context.conversationId = _requiredUuid(
      _object(_object(first.body)['session'])['sessionId'],
    );
    ledger
      ..register(
        LedgerEntry(
          category: ResourceCategory.conversation,
          disposition: ResourceDisposition.createdByRun,
          creationState: 'CONVERSATION_CREATED',
          ownershipProof: context.createAttempt,
          cleanupHandle: context.conversationId,
          cleanupRequired: true,
        ),
      )
      ..register(
        LedgerEntry(
          category: ResourceCategory.sessionState,
          disposition: ResourceDisposition.createdByRun,
          creationState: 'CONVERSATION_CREATED',
          ownershipProof: context.createAttempt,
          cleanupHandle: context.conversationId,
          cleanupRequired: false,
        ),
      )
      ..register(
        LedgerEntry(
          category: ResourceCategory.idempotency,
          disposition: ResourceDisposition.createdByRun,
          creationState: 'CONVERSATION_CREATED',
          ownershipProof: context.createAttempt,
          cleanupHandle: context.ownerId,
          cleanupRequired: true,
        ),
      );
    _advance('CONVERSATION_CREATED', 'CONVERSATION_CREATED');
  }

  Future<_HttpResult> _createConversationRequest() => client.request(
    method: 'POST',
    uri: client.endpoint('/functions/v1/create-own-chat-session'),
    token: context.ownerToken,
    headers: {'Idempotency-Key': context.createAttempt},
    body: {'selectableSpecialistId': context.selectableSpecialistId},
  );

  Future<void> validateReplayStage() async {
    final replay = await _createConversationRequest();
    if (replay.status != 200) throw StateError('IDEMPOTENCY_REPLAY_FAILED');
    final replayId = _requiredUuid(
      _object(_object(replay.body)['session'])['sessionId'],
    );
    final count = await _attributableConversationCount();
    final input = ReplayInput(
      operationAttempt: context.createAttempt,
      idempotencyKey: context.createAttempt,
      normalizedRequest: context.selectableSpecialistId,
    );
    if (!validateReplay(
      first: input,
      replay: input,
      firstCanonicalResult: context.conversationId,
      replayCanonicalResult: replayId,
      attributableConversationCount: count,
    )) {
      throw StateError('IDEMPOTENCY_REPLAY_FAILED');
    }
    _advance('IDEMPOTENCY_REPLAY_VALIDATED', 'IDEMPOTENCY_REPLAY_VALIDATED');
  }

  Future<int> _attributableConversationCount() async {
    final idempotency = await client.request(
      method: 'GET',
      uri: client.endpoint('/rest/v1/conversation_idempotency', {
        'subject_id': 'eq.${context.ownerId}',
        'operation': 'eq.createOwnChatSession',
        'idempotency_key': 'eq.${context.createAttempt}',
        'select': 'result_metadata',
      }),
    );
    final rows = _list(idempotency.body);
    if (idempotency.status != 200 || rows.length != 1) return -1;
    final sessions = await client.request(
      method: 'GET',
      uri: client.endpoint('/rest/v1/chat_sessions', {
        'id': 'eq.${context.conversationId}',
        'user_id': 'eq.${context.ownerId}',
        'select': 'id',
      }),
    );
    return sessions.status == 200 ? _list(sessions.body).length : -1;
  }

  Future<List<List<Map<String, Object?>>>> _listConversationPages(
    String status,
  ) async {
    final pages = <List<Map<String, Object?>>>[];
    final seenCursors = <String>{};
    String? cursor;
    for (var page = 0; page < 50; page++) {
      final query = <String, String>{'status': status, 'limit': '20'};
      if (cursor != null) query['cursor'] = cursor;
      final result = await client.request(
        method: 'GET',
        uri: client.endpoint('/functions/v1/list-own-chat-sessions', query),
        token: context.ownerToken,
      );
      if (result.status != 200) throw StateError('ACTIVE_LIST_FAILED');
      final response = _object(result.body);
      pages.add(_list(response['items']));
      final next = response['nextCursor'];
      if (next == null) return pages;
      if (next is! String || next.isEmpty || !seenCursors.add(next)) {
        throw StateError('ACTIVE_LIST_FAILED');
      }
      cursor = next;
    }
    throw StateError('ACTIVE_LIST_FAILED');
  }

  Future<void> validateActiveList() async {
    final pages = await _listConversationPages('active');
    if (!validateConversationList(
      pages: pages,
      expectedConversationId: context.conversationId,
      expectedStatus: 'active',
    )) {
      throw StateError('ACTIVE_LIST_FAILED');
    }
    _advance('ACTIVE_LIST_VALIDATED', 'ACTIVE_LIST_VALIDATED');
  }

  Future<Map<String, Object?>> _detail(String token) async {
    final result = await client.request(
      method: 'POST',
      uri: client.endpoint('/functions/v1/read-own-conversation'),
      token: token,
      body: {'conversationId': context.conversationId},
    );
    if (result.status != 200) throw StateError('DETAIL_READ_FAILED');
    return _object(_object(result.body)['conversation']);
  }

  Future<void> validateDetail() async {
    final detail = await _detail(context.ownerToken);
    final messages = await _messages();
    if (!validateConversationDetail(
      detail: detail,
      expectedConversationId: context.conversationId,
      expectedSpecialistId: context.selectableSpecialistId,
      expectedStatus: 'active',
      messages: messages,
      expectEmptyMessages: true,
    )) {
      throw StateError('DETAIL_READ_FAILED');
    }
    _advance('DETAIL_READ_VALIDATED', 'DETAIL_READ_VALIDATED');
  }

  Future<void> sendUserMessage() async {
    final result = await client.request(
      method: 'POST',
      uri: client.endpoint('/functions/v1/send-user-message'),
      token: context.ownerToken,
      headers: {'Idempotency-Key': context.messageAttempt},
      body: {
        'sessionId': context.conversationId,
        'content': context.messageContent,
      },
    );
    if (result.status != 201) throw StateError('MESSAGE_SEND_FAILED');
    context.messageId = _requiredUuid(
      _object(_object(result.body)['message'])['messageId'],
    );
    ledger.register(
      LedgerEntry(
        category: ResourceCategory.messages,
        disposition: ResourceDisposition.createdByRun,
        creationState: 'MESSAGE_SENT',
        ownershipProof: context.messageAttempt,
        cleanupHandle: context.messageId,
        cleanupRequired: true,
      ),
    );
    _advance('MESSAGE_SENT', 'MESSAGE_SENT');
  }

  Future<List<Map<String, Object?>>> _messages() async {
    final result = await client.request(
      method: 'GET',
      uri: client.endpoint('/functions/v1/list-session-messages', {
        'sessionId': context.conversationId,
        'limit': '20',
      }),
      token: context.ownerToken,
    );
    if (result.status != 200) throw StateError('UNEXPECTED_AI_OUTPUT');
    return _list(_object(result.body)['items']);
  }

  Future<void> validateNoAi() async {
    final messages = await _messages();
    final normalized = messages
        .map(
          (message) => <String, Object?>{
            'role': message['role'],
            'author': _object(message['author'])['type'],
            'provenance': message['provenance'],
            'visibility': message['visibility'],
          },
        )
        .toList(growable: false);
    if (!validateNoAiEvidence(
      messages: normalized,
      modelGatewayInvocations: 0,
      stasisEngineInvocations: 0,
    )) {
      throw StateError('UNEXPECTED_AI_OUTPUT');
    }
    _advance('NO_AI_VALIDATED', 'NO_AI_VALIDATED');
  }

  Future<void> archiveConversation() async {
    final result = await client.request(
      method: 'POST',
      uri: client.endpoint('/functions/v1/archive-own-chat-session'),
      token: context.ownerToken,
      body: {'sessionId': context.conversationId},
    );
    if (result.status != 200 ||
        _object(_object(result.body)['session'])['status'] != 'archived') {
      throw StateError('ARCHIVE_FAILED');
    }
    _advance('ARCHIVED', 'ARCHIVED');
  }

  Future<void> validateArchivedState() async {
    final detail = await _detail(context.ownerToken);
    final activePages = await _listConversationPages('active');
    final active = activePages.expand((page) => page);
    final blockedSend = await client.request(
      method: 'POST',
      uri: client.endpoint('/functions/v1/send-user-message'),
      token: context.ownerToken,
      headers: {'Idempotency-Key': '${context.alias}_blocked_0001'},
      body: {
        'sessionId': context.conversationId,
        'content': 'synthetic blocked message',
      },
    );
    if (!validateLifecycleState(
      observedStatus: detail['status'] as String? ?? '',
      expectedStatus: 'archived',
      presentInActiveList: active.any(
        (item) => item['sessionId'] == context.conversationId,
      ),
      composerEnabled: blockedSend.status < 400,
    )) {
      throw StateError('ARCHIVED_STATE_INVALID');
    }
    _advance('ARCHIVED_STATE_VALIDATED', 'ARCHIVED_STATE_VALIDATED');
  }

  Future<void> restoreConversation() async {
    final result = await client.request(
      method: 'POST',
      uri: client.endpoint('/functions/v1/restore-own-conversation'),
      token: context.ownerToken,
      body: {'conversationId': context.conversationId},
    );
    if (result.status != 200 ||
        _object(_object(result.body)['conversation'])['status'] != 'active') {
      throw StateError('RESTORE_FAILED');
    }
    _advance('RESTORED', 'RESTORED');
  }

  Future<void> validateRestoredState() async {
    final detail = await _detail(context.ownerToken);
    final activePages = await _listConversationPages('active');
    final active = activePages.expand((page) => page);
    if (!validateLifecycleState(
      observedStatus: detail['status'] as String? ?? '',
      expectedStatus: 'active',
      presentInActiveList:
          active
              .where((item) => item['sessionId'] == context.conversationId)
              .length ==
          1,
      composerEnabled: true,
    )) {
      throw StateError('RESTORED_STATE_INVALID');
    }
    _advance('RESTORED_STATE_VALIDATED', 'RESTORED_STATE_VALIDATED');
  }

  Future<void> validateForeignOpacity() async {
    final created = await client.request(
      method: 'POST',
      uri: client.endpoint('/auth/v1/admin/users'),
      body: {
        'email': context.foreignEmail,
        'password': context.password,
        'email_confirm': true,
      },
    );
    if (created.status != 200) {
      throw StateError('OWNERSHIP_OPACITY_FAILED');
    }
    context.foreignId = _requiredUuid(_object(created.body)['id']);
    ledger.register(
      LedgerEntry(
        category: ResourceCategory.foreignAuth,
        disposition: ResourceDisposition.createdByRun,
        creationState: 'RESTORED_STATE_VALIDATED',
        ownershipProof: context.alias,
        cleanupHandle: context.foreignId,
        cleanupRequired: true,
      ),
    );
    context.foreignToken = await _login(context.foreignEmail);
    final result = await client.request(
      method: 'POST',
      uri: client.endpoint('/functions/v1/read-own-conversation'),
      token: context.foreignToken,
      body: {'conversationId': context.conversationId},
    );
    if (!validateOpaqueForeignResponse(
      status: result.status,
      body: result.body,
    )) {
      throw StateError('OWNERSHIP_OPACITY_FAILED');
    }
    _advance('OWNERSHIP_OPACITY_VALIDATED', 'OWNERSHIP_OPACITY_VALIDATED');
  }

  Future<void> validateBlockedRoutes() async {
    final chat = await client.request(
      method: 'GET',
      uri: context.productOrigin.resolve('/chat'),
    );
    final orchestrator = await client.request(
      method: 'GET',
      uri: context.productOrigin.resolve('/orchestrator'),
    );
    if (classifyChatRoute(chat.status, location: chat.location) !=
            ProductRouteResult.absent ||
        classifyOrchestratorRoute(
              orchestrator.status,
              location: orchestrator.location,
            ) !=
            ProductRouteResult.blockedForProduct) {
      throw StateError('BLOCKED_ROUTES_FAILED');
    }
    _advance('BLOCKED_ROUTES_VALIDATED', 'BLOCKED_ROUTES_VALIDATED');
  }

  void completeFlow() => _advance('FLOW_COMPLETED', 'FLOW_COMPLETED');

  void startCleanup() {
    if (state.state == 'FLOW_COMPLETED') {
      _advance('CLEANUP_STARTED', 'CLEANUP_STARTED');
    } else {
      state.beginCleanupAfterFailure();
      stdout.writeln('state=CLEANUP_STARTED');
    }
  }

  Future<void> _finish() async {
    try {
      startCleanup();
      cleanupPassed = await cleanupLedger();
      if (cleanupPassed) {
        _advance('CLEANUP_COMPLETED', 'CLEANUP_COMPLETED');
        authAbsent = await validateAuthAbsence();
        if (authAbsent) {
          _advance('AUTH_ABSENCE_VALIDATED', 'AUTH_ABSENCE_VALIDATED');
          counters = await validateResidueCounters();
          if (counters!.every((count) => count == 0)) {
            _advance('RESIDUE_VERIFIED', 'RESIDUE_VERIFIED');
            cliIsolated = await isolateCli();
            if (cliIsolated) {
              _advance('CLI_ISOLATED', 'CLI_ISOLATED');
              await runLocalRegression();
              _advance(
                'LOCAL_REGRESSION_COMPLETED',
                'LOCAL_REGRESSION_COMPLETED',
              );
              ledger.delete();
            }
          }
        }
      }
    } on Object {
      cleanupPassed = false;
    } finally {
      if (!cliIsolated) cliIsolated = await isolateCli();
    }
  }

  Future<bool> cleanupLedger() async {
    var clean = true;
    for (final entry in ledger.entriesForCleanup()) {
      final result = await _deleteEntry(entry);
      if (!result) {
        clean = false;
        break;
      }
      ledger.markCleaned(entry.category);
    }
    return clean;
  }

  Future<bool> _deleteEntry(LedgerEntry entry) async {
    late final Uri uri;
    switch (entry.category) {
      case ResourceCategory.messages:
        uri = client.endpoint('/rest/v1/messages', {
          'session_id': 'eq.${context.conversationId}',
        });
      case ResourceCategory.idempotency:
        uri = client.endpoint('/rest/v1/conversation_idempotency', {
          'subject_id': 'eq.${context.ownerId}',
        });
      case ResourceCategory.conversation:
        uri = client.endpoint('/rest/v1/chat_sessions', {
          'id': 'eq.${context.conversationId}',
        });
      case ResourceCategory.profile:
        uri = client.endpoint('/rest/v1/users', {
          'id': 'eq.${context.ownerId}',
        });
      case ResourceCategory.catalog:
      case ResourceCategory.specialist:
        throw StateError('READ_ONLY_CLEANUP_BLOCKED');
      case ResourceCategory.foreignAuth:
        uri = client.endpoint('/auth/v1/admin/users/${context.foreignId}');
      case ResourceCategory.ownerAuth:
        uri = client.endpoint('/auth/v1/admin/users/${context.ownerId}');
      case ResourceCategory.sessionState:
        return true;
    }
    final result = await client.request(method: 'DELETE', uri: uri);
    if (entry.category == ResourceCategory.ownerAuth ||
        entry.category == ResourceCategory.foreignAuth) {
      return result.status == 200 || result.status == 404;
    }
    return {200, 204}.contains(result.status);
  }

  Future<bool> validateAuthAbsence() async {
    for (final id in [context.ownerId, context.foreignId]) {
      if (id.isEmpty) continue;
      final result = await client.request(
        method: 'GET',
        uri: client.endpoint('/auth/v1/admin/users/$id'),
      );
      if (result.status != 404) return false;
    }
    return true;
  }

  Future<List<int>> validateResidueCounters() async {
    final counts = <int>[];
    for (final spec in [
      (
        '/rest/v1/messages',
        {'session_id': 'eq.${context.conversationId}', 'select': 'id'},
      ),
      (
        '/rest/v1/conversation_idempotency',
        {'subject_id': 'eq.${context.ownerId}', 'select': 'id'},
      ),
      (
        '/rest/v1/chat_sessions',
        {'user_id': 'eq.${context.ownerId}', 'select': 'id'},
      ),
      ('/rest/v1/users', {'id': 'eq.${context.ownerId}', 'select': 'id'}),
    ]) {
      final result = await client.request(
        method: 'GET',
        uri: client.endpoint(spec.$1, spec.$2),
      );
      final body = result.body;
      if (result.status != 200 || body is! List<Object?>) {
        throw StateError('RESIDUE_UNKNOWN_OR_NONZERO');
      }
      counts.add(body.length);
    }
    // This attempt cannot create these categories; the ledger is authoritative.
    for (final category in [
      ResourceCategory.catalog,
      ResourceCategory.specialist,
    ]) {
      final entry = ledger[category];
      if (entry == null ||
          entry.disposition !=
              ResourceDisposition.verifiedPreexistingReadOnly ||
          !entry.verificationCompleted) {
        throw StateError('RESIDUE_UNKNOWN_OR_NONZERO');
      }
      counts.add(0);
    }
    var authCount = 0;
    for (final id in [context.ownerId, context.foreignId]) {
      if (id.isEmpty) continue;
      final result = await client.request(
        method: 'GET',
        uri: client.endpoint('/auth/v1/admin/users/$id'),
      );
      if (result.status == 200) {
        authCount++;
      } else if (result.status != 404) {
        throw StateError('RESIDUE_UNKNOWN_OR_NONZERO');
      }
    }
    counts.add(authCount);
    return counts;
  }

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
      ], workingDirectory: Directory.current.path);
      return result.exitCode == 0;
    } on Object {
      return false;
    }
  }

  Future<void> runLocalRegression() async {
    final commands = <(String, List<String>)>[
      ('flutter', ['analyze', '--no-fatal-infos']),
      ('flutter', ['test']),
      ('deno', ['fmt', '--check', 'supabase/functions']),
      ('deno', ['test', 'supabase/functions']),
      ('supabase', ['db', 'reset', '--local', '--no-seed']),
      ('supabase', ['test', 'db', '--local']),
    ];
    for (final command in commands) {
      final result = await Process.run(
        command.$1,
        command.$2,
        workingDirectory: Directory.current.path,
      );
      if (result.exitCode != 0) {
        throw StateError('LOCAL_REGRESSION_FAILED');
      }
    }
  }

  Future<void> _emitSafeAuthDiagnostic(_HttpResult result) async {
    final directory = await Directory.systemTemp.createTemp(
      'stasisly-r2d-diagnostic.',
    );
    try {
      final bodyFile = File('${directory.path}/body.json')
        ..writeAsStringSync(jsonEncode(result.body));
      final outputFile = File('${directory.path}/diagnostic.txt');
      final process = await Process.run(Platform.resolvedExecutable, [
        'run',
        'tool/safe_http_diagnostic.dart',
        '--operation',
        'syntheticUserCreate',
        '--status-code',
        '${result.status}',
        '--content-type',
        'application/json',
        '--duration-seconds',
        '0',
        '--transport-result',
        'ok',
        '--body-file',
        bodyFile.path,
        '--cleanup-required',
        'true',
        '--output-file',
        outputFile.path,
      ], workingDirectory: Directory.current.path);
      if (process.exitCode != 0 || !outputFile.existsSync()) {
        throw StateError('SAFE_HTTP_DIAGNOSTIC_FAILED');
      }
      final safe = outputFile.readAsStringSync();
      if (!safe.startsWith('SAFE_HTTP_DIAGNOSTIC_BEGIN\n') ||
          !safe.trimRight().endsWith('SAFE_HTTP_DIAGNOSTIC_END')) {
        throw StateError('SAFE_HTTP_DIAGNOSTIC_FAILED');
      }
      stdout.write(safe);
    } finally {
      directory.deleteSync(recursive: true);
    }
  }
}

Future<int> runCompleteFunctionalRunner(Map<String, String> environment) async {
  final manifest = CompleteRunnerManifest.read(File(_manifestPath));
  final context = _RunContext(environment);
  final client = _RemoteClient(
    baseUrl: context.baseUrl,
    anonKey: environment['SUPABASE_ANON_KEY'] ?? '',
    serviceRoleKey: environment['SUPABASE_SERVICE_ROLE_KEY'] ?? '',
  );
  final execution = _FunctionalExecution(
    context: context,
    manifest: manifest,
    client: client,
  );
  await execution.run();
  final classification = classifyCompleteRun(
    flowPassed: execution.flowPassed,
    cleanupPassed: execution.cleanupPassed,
    authAbsent: execution.authAbsent,
    counters: execution.counters,
    evidenceSafe: execution.evidenceSafe,
    cliIsolated: execution.cliIsolated,
  );
  stdout.writeln('classification=${classification.value}');
  return switch (classification) {
    CompleteRunClassification.passedClean => 0,
    CompleteRunClassification.failedClean => 1,
    CompleteRunClassification.failedDirtyBlocking => 2,
  };
}

Future<void> main(List<String> arguments) async {
  if (arguments.length != 1) {
    exitCode = 64;
    return;
  }
  if (arguments.single == '--validate-contract') {
    final manifest = CompleteRunnerManifest.read(File(_manifestPath));
    final findings = manifest.validate();
    if (findings.isNotEmpty) {
      stderr.writeln('EXECUTABLE_RUNNER_CONTRACT_BLOCKED');
      exitCode = 1;
      return;
    }
    stdout.write(
      'CANONICAL_SPECIALIST_CONTRACT_PASS\n'
      'MANIFEST_RUNNER_SPECIALIST_SEMANTICS_MATCH\n'
      'EXECUTABLE_RUNNER_CONTRACT_COMPLETE\n',
    );
    return;
  }
  if (arguments.single != '--authorized-development-run') {
    exitCode = 64;
    return;
  }
  exitCode = await runCompleteFunctionalRunner(Platform.environment);
}

Map<String, Object?> _object(Object? value) {
  if (value is! Map) throw const FormatException('Expected object.');
  return Map<String, Object?>.from(value);
}

List<Map<String, Object?>> _list(Object? value) {
  if (value is! List) throw const FormatException('Expected list.');
  return value
      .map((item) => Map<String, Object?>.from(item as Map))
      .toList(growable: false);
}

String _requiredUuid(Object? value) {
  if (value is! String ||
      !RegExp(
        r'^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        caseSensitive: false,
      ).hasMatch(value)) {
    throw const FormatException('Expected UUID.');
  }
  return value;
}

String _syntheticEmail(String localPart) {
  final reservedDomain = <String>['example', 'test'].join('.');
  return '$localPart@$reservedDomain';
}
