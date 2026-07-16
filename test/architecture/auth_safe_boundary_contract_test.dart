import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final safeBoundaryDirectories = [
    Directory('lib/core/auth/session'),
    Directory('lib/features/chat_sessions'),
    Directory('lib/features/chat_messages'),
  ];

  Iterable<File> filesUnder(Directory directory) {
    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
  }

  test('safe auth/session boundary never imports legacy auth', () {
    final files = filesUnder(Directory('lib/core/auth/session')).toList();

    expect(files, isNotEmpty);
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'features/auth',
        'auth_providers',
        'AuthController',
        'authControllerProvider',
        'SupabaseAuthDataSource',
        'AuthRepositoryImpl',
        'Supabase.instance.client',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('safe chat fronts do not depend on legacy auth providers', () {
    final files = [
      ...filesUnder(Directory('lib/features/chat_sessions')),
      ...filesUnder(Directory('lib/features/chat_messages')),
    ];

    expect(files, isNotEmpty);
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'features/auth',
        'auth_providers',
        'AuthController',
        'authControllerProvider',
        'SupabaseAuthDataSource',
        'AuthRepositoryImpl',
        'SignInUseCase',
        'SignUpUseCase',
        'SignOutUseCase',
        'LoginPage',
        'RegisterPage',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('safe boundary has no direct Supabase or remote auth SDK coupling', () {
    final files = safeBoundaryDirectories.expand(filesUnder).toList();

    expect(files, isNotEmpty);
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'Supabase.instance',
        'functions.invoke',
        'auth.signIn',
        'auth.signUp',
        'auth.signOut',
        'auth.currentUser',
        'auth.onAuthStateChange',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('legacy auth consumers now depend on the owned identity port', () {
    final legacyAuthProvider = File(
      'lib/features/auth/presentation/viewmodels/auth_providers.dart',
    ).readAsStringSync();
    final routes = File('lib/core/config/routes.dart').readAsStringSync();

    expect(legacyAuthProvider, contains('identityProviderProvider'));
    expect(legacyAuthProvider, isNot(contains('Supabase.instance.client')));
    expect(legacyAuthProvider, isNot(contains('supabase_flutter')));
    expect(legacyAuthProvider, contains('class AuthController'));
    expect(routes, contains('secureSessionStateProvider'));
    expect(routes, isNot(contains('authControllerProvider')));

    final safeExports = File(
      'lib/core/auth/session/secure_session.dart',
    ).readAsStringSync();
    expect(safeExports, isNot(contains('features/auth')));
    expect(safeExports, isNot(contains('auth_providers')));
    expect(safeExports, isNot(contains('AuthController')));
  });
}
