import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart';

void main() {
  const enabled = LocalOnlyHostPolicy(localValidationEnabled: true);

  test('accepts only explicit localhost and loopback HTTP ports', () {
    expect(enabled.allows(Uri.parse('http://localhost:54321')), isTrue);
    expect(enabled.allows(Uri.parse('http://127.0.0.1:54321')), isTrue);
  });

  test('rejects remote, HTTPS, missing port and unsafe URI components', () {
    for (final uri in [
      'https://localhost:54321',
      'https://project.supabase.co',
      'http://project.supabase.co:54321',
      'http://localhost',
      'http://localhost:54321/functions',
      'http://token@localhost:54321',
      'http://localhost:54321?projectRef=remote',
      'http://localhost:54321#remote',
    ]) {
      expect(enabled.allows(Uri.parse(uri)), isFalse, reason: uri);
    }
  });

  test('rejects every host when local validation is disabled', () {
    const disabled = LocalOnlyHostPolicy(localValidationEnabled: false);

    expect(disabled.allows(Uri.parse('http://localhost:54321')), isFalse);
  });
}
