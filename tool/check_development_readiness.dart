import 'dart:convert';
import 'dart:io';

import 'check_supabase_remote_context.dart';
import 'development_evidence_contracts.dart';
import 'development_remote_execution_contracts.dart';

enum DevelopmentReadinessFindingKind {
  remoteContext,
  missingManifest,
  invalidManifest,
  approvedManifest,
  assignedProject,
  executedRemoteState,
  incompleteMigrationInventory,
  incompleteFunctionInventory,
  incompleteConfigurationInventory,
  incompleteCapabilityMatrix,
  incompleteSkipClassification,
  secretValueDetected,
  serverCredentialInFlutter,
  missingCatalogContract,
  missingLocalCreateSmoke,
  invalidFixtureLifecycle,
  invalidEvidenceContracts,
  unclassifiedRetention,
  invalidRemoteFixtureContract,
  invalidRemoteCleanupContract,
  invalidRemoteSkipGate,
}

final class DevelopmentReadinessFinding {
  const DevelopmentReadinessFinding(this.kind, this.path);

  final DevelopmentReadinessFindingKind kind;
  final String path;

  String get safeDescription => switch (kind) {
    DevelopmentReadinessFindingKind.remoteContext =>
      'Remote CLI context or remote-capable tooling detected.',
    DevelopmentReadinessFindingKind.missingManifest =>
      'Development deployment manifest is missing.',
    DevelopmentReadinessFindingKind.invalidManifest =>
      'Development deployment manifest is invalid.',
    DevelopmentReadinessFindingKind.approvedManifest =>
      'Development deployment manifest must remain unapproved.',
    DevelopmentReadinessFindingKind.assignedProject =>
      'Development project must remain unassigned.',
    DevelopmentReadinessFindingKind.executedRemoteState =>
      'Development remote execution state must remain not executed.',
    DevelopmentReadinessFindingKind.incompleteMigrationInventory =>
      'Development migration inventory is incomplete.',
    DevelopmentReadinessFindingKind.incompleteFunctionInventory =>
      'Development function inventory is incomplete.',
    DevelopmentReadinessFindingKind.incompleteConfigurationInventory =>
      'Development configuration inventory is incomplete.',
    DevelopmentReadinessFindingKind.incompleteCapabilityMatrix =>
      'Development capability matrix is incomplete.',
    DevelopmentReadinessFindingKind.incompleteSkipClassification =>
      'Approved skip classification is incomplete or enabled.',
    DevelopmentReadinessFindingKind.secretValueDetected =>
      'A versionable example or manifest contains a secret-like value.',
    DevelopmentReadinessFindingKind.serverCredentialInFlutter =>
      'Server-only credential configuration detected in Flutter source.',
    DevelopmentReadinessFindingKind.missingCatalogContract =>
      'Canonical selectable-specialist catalog contract is missing.',
    DevelopmentReadinessFindingKind.missingLocalCreateSmoke =>
      'Local canonical create smoke test is missing.',
    DevelopmentReadinessFindingKind.invalidFixtureLifecycle =>
      'Development fixture lifecycle is invalid.',
    DevelopmentReadinessFindingKind.invalidEvidenceContracts =>
      'Development evidence schemas or artifacts are invalid.',
    DevelopmentReadinessFindingKind.unclassifiedRetention =>
      'Conversation idempotency retention is not explicitly classified.',
    DevelopmentReadinessFindingKind.invalidRemoteFixtureContract =>
      'Development remote fixture contract is invalid.',
    DevelopmentReadinessFindingKind.invalidRemoteCleanupContract =>
      'Development remote cleanup contract is invalid.',
    DevelopmentReadinessFindingKind.invalidRemoteSkipGate =>
      'Development remote skip gate is invalid or enabled.',
  };
}

final class DevelopmentReadinessChecker {
  DevelopmentReadinessChecker(this.root);

  final Directory root;

  static const manifestPath =
      'docs/stasisly_foundation/development/'
      'development_deployment_manifest.json';

  static const expectedMigrations = <String>{
    '00001_initial_schema.sql',
    '00002_enable_rls_public_users_deny_all.sql',
    '00003_public_users_owner_profile_minimal.sql',
    '00004_create_specialist_catalog_deny_all.sql',
    '00005_harden_chat_sessions_deny_all.sql',
    '00006_harden_messages_deny_all.sql',
    '00007_create_send_user_message_core_rpc.sql',
    '00008_prepare_product_catalog_schema.sql',
    '00009_harden_legacy_public_tables_deny_all.sql',
    '00010_add_conversation_idempotency_and_transactional_creation.sql',
    '00011_add_canonical_conversation_read_and_lifecycle.sql',
    '00012_add_message_author_provenance_and_visibility.sql',
  };

  static const expectedFunctions = <String>{
    'archive-own-chat-session',
    'create-own-chat-session',
    'list-own-chat-sessions',
    'list-selectable-specialists',
    'list-session-messages',
    'read-own-conversation',
    'restore-own-conversation',
    'send-user-message',
  };

  static const requiredPublicConfigurationNames = <String>{
    'APP_MODE',
    'BACKEND_TARGET_ENVIRONMENT',
    'SUPABASE_URL',
    'SUPABASE_ANON_KEY',
    'ENABLE_REMOTE_BACKEND',
    'ENABLE_REAL_AUTH',
    'ENABLE_REAL_DATA',
    'ENABLE_CONVERSATIONS_ROUTE',
    'ALLOW_SYNTHETIC_DATA',
    'ALLOW_DEV_ROUTES',
  };

  static const requiredCapabilities = <String>{
    'productRoutes',
    'authentication',
    'conversationListRead',
    'conversationCreate',
    'messageSend',
    'archiveRestore',
    'observability',
    'ai',
    'stasisEngine',
    'payments',
    'notifications',
    'adminOperations',
  };

  static const expectedSkipPaths = <String>{
    'test/integration/two_b_iv_h_local_http_chat_sessions_integration_test.dart',
    'test/integration/two_b_v_g_local_http_chat_messages_integration_test.dart',
    'test/features/chat_sessions/data/development_remote_read_test.dart',
    'test/features/chat_sessions/data/development_remote_write_test.dart',
    'test/features/chat_messages/presentation/development_remote_ux_read_test.dart',
  };

  List<DevelopmentReadinessFinding> check() {
    final findings = <DevelopmentReadinessFinding>[];
    if (SupabaseRemoteContextScanner(root).scan().isNotEmpty) {
      findings.add(
        const DevelopmentReadinessFinding(
          DevelopmentReadinessFindingKind.remoteContext,
          'repository',
        ),
      );
    }

    final manifestFile = File(_resolve(manifestPath));
    if (!manifestFile.existsSync()) {
      findings.add(
        const DevelopmentReadinessFinding(
          DevelopmentReadinessFindingKind.missingManifest,
          manifestPath,
        ),
      );
      return findings;
    }

    final Map<String, Object?> manifest;
    try {
      final decoded = jsonDecode(manifestFile.readAsStringSync());
      if (decoded is! Map<String, Object?>) throw const FormatException();
      manifest = decoded;
    } on FormatException {
      findings.add(
        const DevelopmentReadinessFinding(
          DevelopmentReadinessFindingKind.invalidManifest,
          manifestPath,
        ),
      );
      return findings;
    }

    _validateStates(manifest, findings);
    _validateInventory(manifest, findings);
    _validateExamplesAndSecretNames(manifest, findings);
    _validateFlutterCredentialBoundary(findings);
    _validateExecutionBlockers(manifest, findings);
    _validateRemotePreparation(manifest, findings);
    return findings;
  }

  void _validateRemotePreparation(
    Map<String, Object?> manifest,
    List<DevelopmentReadinessFinding> findings,
  ) {
    final allowedWebOrigins = manifest['allowedWebOrigins'];
    final contractFindings = DevelopmentRemotePreparationValidator(
      root,
    ).validateContracts();
    for (final finding in contractFindings) {
      if (finding.toLowerCase().contains('skip gate')) {
        _add(findings, DevelopmentReadinessFindingKind.invalidRemoteSkipGate);
      } else if (finding.toLowerCase().contains('cleanup')) {
        _add(
          findings,
          DevelopmentReadinessFindingKind.invalidRemoteCleanupContract,
        );
      } else {
        _add(
          findings,
          DevelopmentReadinessFindingKind.invalidRemoteFixtureContract,
        );
      }
    }
    if (manifest['fixtureManifestVersion'] != 'FOUNDATION-019A-R1-v1' ||
        manifest['cleanupContractVersion'] != 'FOUNDATION-019A-R1-v1' ||
        manifest['remoteSkipGateVersion'] != 'FOUNDATION-019A-R1-v1' ||
        manifest['allowedWebOriginStatus'] != 'UNASSIGNED' ||
        allowedWebOrigins is! List ||
        allowedWebOrigins.isNotEmpty ||
        manifest['authorizedCommit'] != 'REQUIRES_NEW_FOUNDER_AUTHORIZATION' ||
        manifest['operatorStatus'] != 'RUNTIME_INPUT_NOT_COMMITTED' ||
        manifest['founderAuthorizationStatus'] != 'NOT_GRANTED' ||
        manifest['remoteTests'] != 'NOT_ENABLED') {
      _add(findings, DevelopmentReadinessFindingKind.invalidRemoteSkipGate);
    }
  }

  void _validateExecutionBlockers(
    Map<String, Object?> manifest,
    List<DevelopmentReadinessFinding> findings,
  ) {
    final catalog = File(
      _resolve(
        'lib/features/specialists/domain/repositories/'
        'selectable_specialists_repository.dart',
      ),
    );
    if (!catalog.existsSync() ||
        !catalog.readAsStringSync().contains(
          'abstract interface class SelectableSpecialistCatalog',
        )) {
      _add(findings, DevelopmentReadinessFindingKind.missingCatalogContract);
    }
    final smoke = File(
      _resolve(
        'supabase/tests/'
        'foundation_019c_development_fixture_lifecycle_http_test.sh',
      ),
    );
    if (!smoke.existsSync() ||
        !smoke.readAsStringSync().contains('run_cycle 1') ||
        !smoke.readAsStringSync().contains('run_cycle 2') ||
        !smoke.readAsStringSync().contains('run_failure_cycle 1') ||
        !smoke.readAsStringSync().contains('run_failure_cycle 2')) {
      _add(findings, DevelopmentReadinessFindingKind.missingLocalCreateSmoke);
    }
    final evidenceFindings = DevelopmentEvidenceContractValidator(
      root,
    ).validate();
    if (evidenceFindings.isNotEmpty) {
      _add(findings, DevelopmentReadinessFindingKind.invalidEvidenceContracts);
    }
    final fixture = File(
      _resolve(DevelopmentEvidenceContractValidator.fixtureManifestPath),
    );
    if (!fixture.existsSync()) {
      _add(findings, DevelopmentReadinessFindingKind.invalidFixtureLifecycle);
    }
    final retention = manifest['idempotencyRetention'];
    if (retention is! Map<String, Object?> ||
        retention['status'] != 'DECIDED' ||
        retention['classification'] != 'POST_DEVELOPMENT_OPERATIONAL_BLOCKER' ||
        retention['duration'] != 'NOT_ARBITRARILY_ASSIGNED' ||
        retention['destructiveCleanupImplemented'] != false) {
      _add(findings, DevelopmentReadinessFindingKind.unclassifiedRetention);
    }
  }

  void _validateStates(
    Map<String, Object?> manifest,
    List<DevelopmentReadinessFinding> findings,
  ) {
    if (manifest['environment'] != 'development' ||
        manifest['schemaVersion'] != 1) {
      _add(findings, DevelopmentReadinessFindingKind.invalidManifest);
    }
    if (manifest['approval'] != 'NOT_GRANTED') {
      _add(findings, DevelopmentReadinessFindingKind.approvedManifest);
    }
    if (manifest['projectIdentifier'] != 'UNASSIGNED') {
      _add(findings, DevelopmentReadinessFindingKind.assignedProject);
    }
    if (manifest['deployment'] != 'NOT_EXECUTED' ||
        manifest['remoteValidation'] != 'NOT_EXECUTED') {
      _add(findings, DevelopmentReadinessFindingKind.executedRemoteState);
    }
  }

  void _validateInventory(
    Map<String, Object?> manifest,
    List<DevelopmentReadinessFinding> findings,
  ) {
    final diskMigrations = _fileNames('supabase/migrations', '.sql');
    if (!_sameSet(diskMigrations, expectedMigrations) ||
        !_sameSet(
          _stringSet(manifest['expectedMigrations']),
          expectedMigrations,
        )) {
      _add(
        findings,
        DevelopmentReadinessFindingKind.incompleteMigrationInventory,
      );
    }

    final diskFunctions = _directoryNames('supabase/functions')
      ..remove('_shared');
    if (!_sameSet(diskFunctions, expectedFunctions) ||
        !_sameSet(
          _stringSet(manifest['expectedFunctions']),
          expectedFunctions,
        )) {
      _add(
        findings,
        DevelopmentReadinessFindingKind.incompleteFunctionInventory,
      );
    }

    final envExample = File(_resolve('.env.example'));
    final envNames = envExample.existsSync()
        ? envExample
              .readAsLinesSync()
              .where((line) => !line.trimLeft().startsWith('#'))
              .where((line) => line.contains('='))
              .map((line) => line.split('=').first.trim())
              .toSet()
        : <String>{};
    if (!envNames.containsAll(requiredPublicConfigurationNames) ||
        !_sameSet(
          _stringSet(manifest['requiredPublicConfigurationNames']),
          requiredPublicConfigurationNames,
        )) {
      _add(
        findings,
        DevelopmentReadinessFindingKind.incompleteConfigurationInventory,
      );
    }

    final capabilities = manifest['capabilities'];
    if (capabilities is! Map<String, Object?> ||
        !_sameSet(capabilities.keys.toSet(), requiredCapabilities) ||
        capabilities.values.any((value) => value == 'ENABLED')) {
      _add(
        findings,
        DevelopmentReadinessFindingKind.incompleteCapabilityMatrix,
      );
    }

    final skips = manifest['remoteSkips'];
    final skipMaps = skips is List
        ? skips.whereType<Map<String, Object?>>().toList()
        : <Map<String, Object?>>[];
    final skipPaths = skipMaps
        .map((item) => item['sourcePath'])
        .whereType<String>()
        .toSet();
    final complete =
        skipMaps.length == expectedSkipPaths.length &&
        _sameSet(skipPaths, expectedSkipPaths) &&
        skipMaps.every(
          (item) =>
              item['status'] == 'CLASSIFIED_NOT_ENABLED' &&
              item['activationGate'] is String &&
              item['requiredSecretNames'] is List &&
              item['cleanup'] is String,
        );
    if (!complete) {
      _add(
        findings,
        DevelopmentReadinessFindingKind.incompleteSkipClassification,
      );
    }
  }

  void _validateExamplesAndSecretNames(
    Map<String, Object?> manifest,
    List<DevelopmentReadinessFinding> findings,
  ) {
    final secretNames = _stringSet(manifest['requiredSecretNames']);
    if (secretNames.isEmpty || secretNames.any((name) => name.contains('='))) {
      _add(findings, DevelopmentReadinessFindingKind.secretValueDetected);
    }

    final example = File(_resolve('.env.example'));
    if (!example.existsSync()) return;
    for (final rawLine in example.readAsLinesSync()) {
      final line = rawLine.trim();
      if (line.isEmpty || line.startsWith('#') || !line.contains('=')) continue;
      final separator = line.indexOf('=');
      final name = line.substring(0, separator);
      final value = line.substring(separator + 1).trim();
      if (_isSensitiveName(name) && value.isNotEmpty && value != 'false') {
        _add(findings, DevelopmentReadinessFindingKind.secretValueDetected);
        return;
      }
    }
  }

  void _validateFlutterCredentialBoundary(
    List<DevelopmentReadinessFinding> findings,
  ) {
    final lib = Directory(_resolve('lib'));
    if (!lib.existsSync()) return;
    for (final file
        in lib
            .listSync(recursive: true, followLinks: false)
            .whereType<File>()
            .where((file) => file.path.endsWith('.dart'))) {
      if (file.readAsStringSync().contains('SUPABASE_SERVICE_ROLE_KEY')) {
        findings.add(
          DevelopmentReadinessFinding(
            DevelopmentReadinessFindingKind.serverCredentialInFlutter,
            _relative(file.path),
          ),
        );
      }
    }
  }

  bool _isSensitiveName(String name) {
    final upper = name.toUpperCase();
    return upper.contains('TOKEN') ||
        upper.contains('SECRET') ||
        upper.contains('PASSWORD') ||
        upper.contains('SERVICE_ROLE') ||
        upper.endsWith('_KEY');
  }

  Set<String> _fileNames(String path, String suffix) {
    final directory = Directory(_resolve(path));
    if (!directory.existsSync()) return {};
    return directory
        .listSync()
        .whereType<File>()
        .map((file) => file.uri.pathSegments.last)
        .where((name) => name.endsWith(suffix))
        .toSet();
  }

  Set<String> _directoryNames(String path) {
    final directory = Directory(_resolve(path));
    if (!directory.existsSync()) return {};
    return directory
        .listSync()
        .whereType<Directory>()
        .map(
          (entry) =>
              entry.uri.pathSegments.where((part) => part.isNotEmpty).last,
        )
        .toSet();
  }

  Set<String> _stringSet(Object? value) =>
      value is List ? value.whereType<String>().toSet() : <String>{};

  bool _sameSet(Set<String> left, Set<String> right) =>
      left.length == right.length && left.containsAll(right);

  void _add(
    List<DevelopmentReadinessFinding> findings,
    DevelopmentReadinessFindingKind kind,
  ) {
    if (findings.any((finding) => finding.kind == kind)) return;
    findings.add(DevelopmentReadinessFinding(kind, manifestPath));
  }

  String _resolve(String relativePath) =>
      '${root.path}${Platform.pathSeparator}$relativePath';

  String _relative(String path) {
    final prefix = '${root.absolute.path}${Platform.pathSeparator}';
    final absolute = File(path).absolute.path;
    return absolute.startsWith(prefix)
        ? absolute.substring(prefix.length).replaceAll(r'\', '/')
        : absolute.replaceAll(r'\', '/');
  }
}

void main(List<String> arguments) {
  final root = arguments.isEmpty
      ? Directory.current
      : arguments.length == 2 && arguments.first == '--root'
      ? Directory(arguments.last).absolute
      : null;
  if (root == null) {
    stderr.writeln('Usage: development readiness preflight [--root PATH]');
    exitCode = 64;
    return;
  }

  final findings = DevelopmentReadinessChecker(root).check();
  if (findings.isEmpty) {
    stdout.writeln('Development local readiness preflight: SAFE.');
    return;
  }

  stderr.writeln('Development local readiness preflight: BLOCKED.');
  for (final finding in findings) {
    stderr.writeln('${finding.safeDescription} Path: ${finding.path}');
  }
  exitCode = 1;
}
