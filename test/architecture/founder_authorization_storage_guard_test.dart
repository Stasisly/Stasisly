import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final gitignore = File('.gitignore').readAsLinesSync();
  final tooling = File(
    'tool/founder_authorization_artifact.dart',
  ).readAsStringSync();
  final runner = File(
    'tool/development_v4_dirty_run_containment_runner.dart',
  ).readAsStringSync();
  final wrapper = File(
    'scripts/run_development_v4_dirty_run_containment.sh',
  ).readAsStringSync();

  test('.runtime has exactly one narrow ignore rule', () {
    expect(gitignore.where((line) => line.trim() == '.runtime/'), hasLength(1));
    expect(gitignore, isNot(contains('*')));
    expect(gitignore, isNot(contains('.runtime/*')));
  });

  test('nested runtime files are ignored and absent from Git status', () {
    final probes = [
      File('.runtime/authorizations/.architecture-ignore-check'),
      File('.runtime/audit/.architecture-ignore-check'),
      File('.runtime/locks/.architecture-ignore-check'),
    ];
    for (final probe in probes) {
      probe.createSync(recursive: true);
    }
    try {
      for (final probe in probes) {
        final ignored = Process.runSync('git', [
          'check-ignore',
          '-v',
          probe.path,
        ]);
        expect(ignored.exitCode, 0, reason: probe.path);
      }
      final status = Process.runSync('git', ['status', '--short']);
      expect(
        status.stdout as String,
        isNot(contains('.architecture-ignore-check')),
      );
    } finally {
      for (final probe in probes) {
        probe.deleteSync();
      }
    }
  });

  test('artifact implementation enforces storage and lifecycle guards', () {
    for (final contract in [
      'AUTHORIZATION_ARTIFACT_STORAGE_NOT_IGNORED',
      'AUTHORIZATION_RUNTIME_FILE_TRACKED',
      'AUTHORIZATION_ARTIFACT_PERMISSIONS_TOO_BROAD',
      'AUTHORIZATION_PAYLOAD_HASH_MISMATCH',
      'AUTHORIZATION_EXPIRED',
      'AUTHORIZATION_ALREADY_CONSUMED',
      'AUTHORIZATION_EXECUTION_COUNT_EXCEEDED',
      'AUTHORIZATION_LOCKED_FAIL_CLOSED',
      'AUTHORIZATION_REGENERATION_BLOCKED',
    ]) {
      expect(tooling, contains(contract), reason: contract);
    }
  });

  test('R2H uses artifact primary path and keeps remote logic isolated', () {
    expect(runner, contains('FOUNDER_AUTHORIZATION_ARTIFACT'));
    expect(runner, contains('store.consume'));
    expect(runner, contains('resolveAuthorizationSource'));
    expect(wrapper, contains('FOUNDER_AUTHORIZATION_ARTIFACT'));
    expect(
      wrapper,
      isNot(contains('FOUNDER_CONTAINMENT_AUTHORIZATION_REFERENCE')),
    );
    expect(wrapper, isNot(contains('AUTHORIZED_COMMIT_SHA')));
    expect(tooling, isNot(contains('SUPABASE_SERVICE_ROLE_KEY')));
  });
}
