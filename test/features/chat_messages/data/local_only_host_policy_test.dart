import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/features/chat_messages/data/local/local_only_host_policy.dart';

void main() {
  const enabled = LocalOnlyHostPolicy(localValidationEnabled: true);

  test('accepts only explicit localhost and loopback HTTP ports', () {
    expect(enabled.allows(Uri.parse('http://localhost:54321')), true);
    expect(enabled.allows(Uri.parse('http://127.0.0.1:54321')), true);
  });

  test('blocks remote, cloud, https, empty host and implicit port', () {
    for (final value in [
      'https://localhost:54321',
      'http://localhost',
      'http://project.supabase.co:54321',
      'https://project.supabase.co',
      'http://example.com:54321',
      'http://:54321',
      'http://127.0.0.1:54321/path',
      'http://127.0.0.1:54321?x=1',
      'http://user@127.0.0.1:54321',
    ]) {
      expect(enabled.allows(Uri.parse(value)), false, reason: value);
    }
  });

  test('blocks every host when local composition is disabled', () {
    const disabled = LocalOnlyHostPolicy(localValidationEnabled: false);

    expect(disabled.allows(Uri.parse('http://127.0.0.1:54321')), false);
  });
}
