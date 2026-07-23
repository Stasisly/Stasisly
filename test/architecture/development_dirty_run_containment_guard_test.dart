import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final contract = File(
    'tool/development_dirty_run_containment.dart',
  ).readAsStringSync();

  test('containment helper has no remote execution primitive', () {
    for (final forbidden in <String>[
      'supabase link',
      'supabase db push',
      'supabase functions deploy',
      'HttpClient',
      'Socket.connect',
      'Process.run',
      'Process.start',
      'curl ',
    ]) {
      expect(contract, isNot(contains(forbidden)), reason: forbidden);
    }
  });

  test('containment identity is exact and broad lookup is absent', () {
    expect(contract, contains('const dirtyAttemptAlias'));
    expect(contract, contains('diag-20260723-002'));
    expect(contract, contains('const dirtyRunNamespace'));
    expect(contract, contains('foundation-019a-r1-diag-20260723-002'));
    expect(contract, contains('const dirtyAttemptCommit'));
    expect(contract, contains('d94292a'));
    expect(contract, isNot(contains('listUsers')));
    expect(contract, isNot(contains('perPage')));
    expect(contract, isNot(contains('wildcard')));
  });
}
