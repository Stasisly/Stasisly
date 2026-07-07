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

  group('DevelopmentRemoteHostPolicy', () {
    const policy = DevelopmentRemoteHostPolicy(
      enabled: true,
      approvedHost: 'project.supabase.co',
    );

    test('accepts only the approved Supabase HTTPS host', () {
      expect(policy.allows(Uri.parse('https://project.supabase.co')), true);
      expect(policy.allows(Uri.parse('https://project.supabase.co/')), true);
    });

    test('blocks unsafe or non-approved remote hosts', () {
      for (final value in [
        'http://project.supabase.co',
        'https://other.supabase.co',
        'https://project.supabase.co:5432',
        'https://project.supabase.co/functions/v1',
        'https://token@project.supabase.co',
        'https://anon:token@project.supabase.co',
        'https://project.supabase.co?apikey=value',
        'https://project.supabase.co?access_token=value',
        'https://project.supabase.co#token',
        'https://localhost',
        'https://127.0.0.1',
        'https://project.pooler.supabase.com',
        'postgresql://user:password@project.supabase.co:5432/postgres',
        'postgres://project.supabase.co',
      ]) {
        expect(policy.allows(Uri.parse(value)), false, reason: value);
      }
    });

    test('blocks every host when disabled or host is empty', () {
      const disabled = DevelopmentRemoteHostPolicy(
        enabled: false,
        approvedHost: 'project.supabase.co',
      );
      const empty = DevelopmentRemoteHostPolicy(
        enabled: true,
        approvedHost: '',
      );

      expect(disabled.allows(Uri.parse('https://project.supabase.co')), false);
      expect(empty.allows(Uri.parse('https://project.supabase.co')), false);
    });
  });
}
