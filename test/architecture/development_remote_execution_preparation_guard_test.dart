import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('local and remote fixture manifests remain separate and fail closed', () {
    final local = _json(
      'docs/stasisly_foundation/development/development_fixture_manifest.json',
    );
    final remote = _json(
      'docs/stasisly_foundation/development/'
      'development_remote_fixture_manifest.json',
    );
    final cleanup = local['cleanupContract'];
    expect(cleanup, isA<Map<String, Object?>>());
    if (cleanup is Map<String, Object?>) {
      expect(cleanup['localOnly'], isTrue);
    }
    expect(remote['executionMode'], 'remoteControlled');
    expect(remote['environment'], 'development');
    expect(remote['cleanupOnSuccess'], 'REQUIRED');
    expect(remote['cleanupOnFailure'], 'REQUIRED');
    expect(remote['partialSetupCleanup'], 'REQUIRED');
    expect(remote['idempotentCleanup'], 'REQUIRED');
    expect(remote['wildcardsAllowed'], isFalse);
    expect(remote['approval'], 'NOT_GRANTED');
    expect(remote['execution'], 'NOT_EXECUTED');
    expect(jsonEncode(remote), isNot(contains('https://')));
  });

  test('remote skips require the shared multi-factor gate and stay disabled', () {
    final gate = _json(
      'docs/stasisly_foundation/development/development_remote_skip_gate.json',
    );
    expect(gate['singleBooleanSufficient'], isFalse);
    expect(gate['environmentAloneSufficient'], isFalse);
    expect(gate['testsEnabled'], isFalse);
    final requiredConditions = gate['requiredConditions'];
    expect(requiredConditions, isA<List<Object?>>());
    if (requiredConditions is List<Object?>) {
      expect(requiredConditions, hasLength(11));
    }

    for (final path in <String>[
      'test/features/chat_sessions/data/development_remote_read_test.dart',
      'test/features/chat_sessions/data/development_remote_write_test.dart',
      'test/features/chat_messages/presentation/development_remote_ux_read_test.dart',
    ]) {
      final source = File(path).readAsStringSync();
      expect(source, contains('DevelopmentRemoteGateInput.fromEnvironment'));
      expect(source, isNot(contains('RUN_REMOTE_TESTS')));
    }
  });

  test(
    'CORS and evidence remain placeholders without inferred remote values',
    () {
      final manifest = _json(
        'docs/stasisly_foundation/development/'
        'development_deployment_manifest.json',
      );
      expect(manifest['projectIdentifier'], 'UNASSIGNED');
      expect(manifest['allowedWebOriginStatus'], 'UNASSIGNED');
      expect(manifest['allowedWebOrigins'], isEmpty);
      expect(manifest['operatorStatus'], 'RUNTIME_INPUT_NOT_COMMITTED');
      expect(manifest['founderAuthorizationStatus'], 'NOT_GRANTED');
      final encoded = jsonEncode(manifest);
      expect(encoded, isNot(contains('supabase.co')));
      expect(encoded, isNot(contains('http://')));
      expect(encoded, isNot(contains('https://')));
    },
  );

  test(
    'remote preparation tools are local validators without network access',
    () {
      for (final path in <String>[
        'tool/development_remote_execution_contracts.dart',
        'tool/check_development_remote_preparation.dart',
        'tool/check_development_readiness.dart',
      ]) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains('HttpClient')));
        expect(source, isNot(contains('Socket.connect')));
        expect(source, isNot(contains('Process.run')));
        expect(source, isNot(contains('Process.start')));
      }
    },
  );

  test(
    'versioned operator runner enforces finally cleanup and exact filters',
    () {
      final source = File(
        'scripts/run_development_remote_fixture_test.sh',
      ).readAsStringSync();
      expect(source, contains('trap finalize EXIT INT TERM'));
      expect(
        source,
        contains('cleanup_remote_fixture && cleanup_remote_fixture'),
      );
      expect(source, contains("'0|0|0|0|0|0|0'"));
      expect(source, contains('FAILED_DIRTY_BLOCKING'));
      expect(source, contains('PASSED_CLEAN'));
      expect(source, contains('FAILED_CLEAN'));
      expect(source, contains('AUTHORIZED_COMMIT_SHA'));
      expect(source, isNot(contains('RUN_REMOTE_TESTS')));
      expect(source, isNot(contains('like.')));
      expect(source, isNot(contains('supabase link')));
    },
  );
}

Map<String, Object?> _json(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, Object?>;
