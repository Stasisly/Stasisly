import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final contracts = File(
    'tool/development_legacy_conversation_recovery_contracts.dart',
  ).readAsStringSync();
  final runner = File(
    'tool/development_legacy_conversation_recovery_runner.dart',
  ).readAsStringSync();
  final manifest =
      jsonDecode(
            File(
              'docs/stasisly_foundation/development/'
              'development_v4_legacy_conversation_recovery_manifest.json',
            ).readAsStringSync(),
          )
          as Map<String, Object?>;

  test('runner contains no remote transport or executable mode', () {
    expect(runner, isNot(contains('HttpClient')));
    expect(runner, isNot(contains('http.')));
    expect(runner, isNot(contains('supabase link')));
    expect(runner, isNot(contains('serviceRole')));
    expect(runner, isNot(contains('functions/v1')));
    expect(runner, isNot(contains('rest/v1')));
    expect(runner, contains("arguments.single != '--validate-contract'"));
    expect(
      runner,
      contains('LEGACY_CONVERSATION_RECOVERY_REMOTE_EXECUTION_BLOCKED'),
    );
  });

  test('manifest permits no query, request or delete', () {
    expect(manifest['remoteAuthorization'], 'NOT_GRANTED');
    expect(manifest['remoteExecution'], 'NOT_EXECUTED');
    expect(manifest['permittedQueryShape'], 'NONE');
    expect(manifest['maximumRequestCount'], 0);
    expect(manifest['maximumResultCardinality'], 0);
    expect(manifest['deleteEnabled'], isFalse);
    expect(manifest['diagnosticOnly'], isTrue);
  });

  test('forbidden discovery strategies are explicit and non-admissible', () {
    final strategies = (manifest['strategies']! as List<Object?>)
        .cast<Map<String, Object?>>();
    for (final name in {
      'OWNER_ONLY',
      'DATE_WINDOW_OR_ORDERING',
      'UNBOUNDED_OR_PAGINATED_LIST',
    }) {
      final strategy = strategies.singleWhere(
        (strategy) => strategy['name'] == name,
      );
      expect(strategy['status'], 'UNSAFE');
      expect(strategy['exactKeyAvailable'], isFalse);
    }
    expect(contracts, isNot(contains('created_at=gte')));
    expect(contracts, isNot(contains('created_at=lte')));
    expect(contracts, isNot(contains('order=created_at')));
    expect(contracts, isNot(contains('.first')));
  });

  test('absence never derives from query errors or partial responses', () {
    final lookupStart = contracts.indexOf(
      'LegacyLookupAssessment assessLegacyLookup',
    );
    final lookupEnd = contracts.indexOf(
      'final class LegacyRecoveryRequestBudget',
      lookupStart,
    );
    final lookup = contracts.substring(lookupStart, lookupEnd);

    expect(lookup, contains('!responseComplete'));
    expect(lookup, contains('paginationPresent'));
    expect(lookup, contains('status != 200'));
    expect(lookup, contains('LegacyLookupCardinality.queryFailed'));
    expect(lookup, contains('LegacyLookupCardinality.exactlyZero'));
  });

  test('messages and sessions require exact Conversation proof', () {
    expect(
      manifest['messagesPolicy'],
      'UNKNOWN_BLOCKING_UNTIL_EXACT_CONVERSATION_PROOF',
    );
    expect(
      manifest['sessionsPolicy'],
      'UNKNOWN_BLOCKING_UNTIL_EXACT_CONVERSATION_PROOF',
    );
    expect(contracts, contains('MESSAGES_UNKNOWN_BLOCKING'));
    expect(contracts, contains('SESSION_REMAINS_UNKNOWN'));
  });

  test('future R2I ledger is not historical evidence', () {
    final evidence = manifest['historicalEvidence']! as Map<String, Object?>;
    expect(evidence['futureR2ILedgerApplicable'], isFalse);
    expect(evidence['conversationHandle'], 'EXACT_BUT_NOT_AVAILABLE');
    expect(evidence['ownerHandle'], 'EXACT_BUT_NOT_AVAILABLE');
  });

  test('dirty run cannot be classified clean', () {
    expect(contracts, isNot(contains('DIAGNOSED_ALREADY_CLEAN')));
    expect(contracts, isNot(contains('CONTAINED_CLEAN')));
    expect(
      contracts,
      contains('LEGACY_CONVERSATION_EXACT_RECOVERY_UNAVAILABLE'),
    );
  });
}
