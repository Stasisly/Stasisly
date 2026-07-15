import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final identityRoot = Directory('lib/core/identity');
  final authRoot = Directory('lib/features/auth');

  Iterable<File> dartFiles(Directory root) {
    return root
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
  }

  test('provider SDK is confined to the authorized adapter', () {
    const allowed =
        'lib/core/identity/infrastructure/supabase_identity_provider.dart';
    final files = [...dartFiles(identityRoot), ...dartFiles(authRoot)];

    for (final file in files) {
      if (file.path == allowed) continue;
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'SupabaseClient',
        'Supabase.instance',
        'AuthResponse',
        'AuthException',
        'supabase.User',
        'supabase.Session',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('owned public contracts contain no credential or authority fields', () {
    final contractFiles = [
      ...dartFiles(Directory('lib/core/identity/domain')),
      ...dartFiles(Directory('lib/core/identity/ports')),
    ];

    for (final file in contractFiles) {
      final source = file.readAsStringSync();
      if (!file.path.endsWith('authentication_token_result.dart')) {
        expect(source, isNot(contains('accessToken')), reason: file.path);
        expect(source, isNot(contains('refreshToken')), reason: file.path);
      }
      for (final forbidden in [
        'ownerUserId',
        'owner_user_id',
        'specialistId',
        'service_role',
        'FounderElevated',
        'FounderEmergency',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('identity port does not make authorization decisions', () {
    final source = File(
      'lib/core/identity/ports/identity_provider.dart',
    ).readAsStringSync();

    for (final forbidden in [
      'authorize',
      'permission',
      'entitlement',
      'elevation',
      'ownership',
      'surfaceAccess',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
  });

  test('presentation and repositories expose only owned contracts', () {
    final files = [
      ...dartFiles(Directory('lib/features/auth/presentation')),
      ...dartFiles(Directory('lib/features/auth/domain')),
      ...dartFiles(Directory('lib/features/auth/data/repositories')),
    ];

    for (final file in files) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'Supabase',
        'AuthResponse',
        'AuthException',
        'accessToken',
        'refreshToken',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('demo identity is selected only by explicit demo mode', () {
    final source = File(
      'lib/core/providers/current_identity_provider.dart',
    ).readAsStringSync();

    expect(source, contains('if (environment.isDemo)'));
    expect(source, contains('CurrentIdentity.demo()'));
    expect(source, isNot(contains('catch')));
  });
}
