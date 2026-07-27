import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final source = File(
    'tool/exact_synthetic_auth_resolution.dart',
  ).readAsStringSync();
  final historicalFixture = File(
    'test/tool/fixtures/foundation_019a_historical_auth_derivation.json',
  ).readAsStringSync();

  test('exact resolution helper is local, provider-neutral and env-free', () {
    for (final forbidden in <String>[
      'HttpClient',
      'Socket.connect',
      'Process.run',
      'Process.start',
      'Platform.environment',
      "File('.env",
      'File(".env',
      'supabase link',
      'supabase db',
      'supabase functions',
      'curl ',
      'service_role',
    ]) {
      expect(source, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('lookup is exact, bounded and fails closed on collisions', () {
    expect(source, contains('matchesExact(record.email)'));
    expect(source, contains('maximumAuthLookupPages'));
    expect(source, contains('multipleMatchesBlocking'));
    expect(source, contains('authorizationRejected'));
    expect(source, contains('environmentMismatch'));
    expect(source, contains('targetMismatch'));
    expect(source, isNot(contains('startsWith(record.email)')));
    expect(source, isNot(contains('contains(record.email)')));
  });

  test(
    'committed artifacts contain aliases and templates, not literal key',
    () {
      final forbiddenLiteral = ['diag-20260723-002', '@example.test'].join();
      expect(source, contains('AUTH_RESOURCE_DIAG_002'));
      expect(historicalFixture, contains('AUTH_RESOURCE_DIAG_002'));
      expect(historicalFixture, contains('{runAlias}@example.test'));
      expect(historicalFixture, isNot(contains(forbiddenLiteral)));
      expect(source, isNot(contains(forbiddenLiteral)));
    },
  );

  test('delete target and lookup key redact operational values', () {
    expect(source, contains('SyntheticAuthLookupKey(<redacted>)'));
    expect(source, contains('ExactSyntheticAuthDeleteTarget(<redacted>)'));
    expect(source, isNot(contains('stdout.writeln(_exactEmail)')));
    expect(source, isNot(contains('stdout.writeln(_authUserId)')));
  });

  test('machine-readable contract is closed, exact and unexecuted', () {
    final contract =
        jsonDecode(
              File(
                'docs/stasisly_foundation/development/'
                'exact_synthetic_auth_resolution.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>;
    expect(contract['matchPolicy'], 'EXACT_CASE_SENSITIVE');
    expect(contract['maximumAcceptedMatches'], 1);
    expect(contract['maximumLookupPages'], 10);
    expect(contract['broadLookupAllowed'], isFalse);
    expect(contract['fuzzyMatchAllowed'], isFalse);
    expect(contract['remoteAuthorization'], 'NOT_GRANTED');
    expect(contract['remoteExecution'], 'NOT_EXECUTED');
    expect(contract['remoteResidue'], 'UNKNOWN');
    final forbiddenLiteral = ['diag-20260723-002', '@example.test'].join();
    expect(contract.toString(), isNot(contains(forbiddenLiteral)));
  });
}
