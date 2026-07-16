import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const shared = 'supabase/functions/_shared/authorization';
  const functions = {
    'list-selectable-specialists': 'listSelectableSpecialists',
    'create-own-chat-session': 'createOwnChatSession',
    'list-own-chat-sessions': 'listOwnChatSessions',
    'archive-own-chat-session': 'archiveOwnChatSession',
    'list-session-messages': 'listSessionMessages',
    'send-user-message': 'sendUserMessage',
  };

  test('backend vocabulary preserves canonical Dart surface and actions', () {
    final backend = File('$shared/foundation_vocabulary.ts').readAsStringSync();
    final dartSurface = File(
      'lib/core/authorization/domain/authorization_surface.dart',
    ).readAsStringSync();
    final dartActions = File(
      'lib/core/authorization/domain/authorization_action.dart',
    ).readAsStringSync();

    for (final value in [
      'product',
      'development',
      'administration',
      'platform',
      'sharedInfrastructure',
      'unknown',
    ]) {
      expect(dartSurface, contains(value));
      expect(backend, contains('"$value"'));
    }
    for (final value in [
      'read',
      'create',
      'update',
      'delete',
      'execute',
      'approve',
      'configure',
      'administer',
      'export',
      'delegate',
      'elevate',
      'unknown',
    ]) {
      expect(dartActions, contains(value));
      expect(backend, contains('"$value"'));
    }
  });

  test('backend environment is a strict Foundation runtime subset', () {
    final backend = File('$shared/foundation_vocabulary.ts').readAsStringSync();
    for (final value in [
      'local',
      'development',
      'staging',
      'production',
      'unknown',
    ]) {
      expect(backend, contains('"$value"'));
    }
    for (final forbidden in [
      'backendReal',
      'demo',
      'preview',
      'sandbox',
      'disasterRecovery',
    ]) {
      expect(backend, isNot(contains('"$forbidden"')));
    }
  });

  test('all six functions use one registered backend operation', () {
    for (final entry in functions.entries) {
      final source = File(
        'supabase/functions/${entry.key}/index.ts',
      ).readAsStringSync();
      expect(source, contains('prepareBackendAuthorization'));
      expect(source, contains('BACKEND_OPERATIONS.${entry.value}'));
      expect(source, isNot(contains('request.headers.get("x-surface")')));
      expect(source, isNot(contains('request.headers.get("x-environment")')));
    }
  });

  test('ownership functions complete final backend enforcement', () {
    for (final name in functions.keys.where(
      (name) => name != 'list-selectable-specialists',
    )) {
      final source = File(
        'supabase/functions/$name/index.ts',
      ).readAsStringSync();
      expect(source, contains('finalizeBackendAuthorization'));
    }
  });

  test('authority metadata is rejected and never becomes context', () {
    final metadata = File('$shared/request_metadata.ts').readAsStringSync();
    final context = File(
      '$shared/backend_request_context.ts',
    ).readAsStringSync();
    for (final field in [
      'x-owner-id',
      'x-role',
      'x-stasisly-surface',
      'x-stasisly-environment',
      'x-entitlement',
    ]) {
      expect(metadata, contains('"$field"'));
    }
    for (final forbidden in [
      'rawJwt',
      'accessToken',
      'refreshToken',
      'serviceRoleKey',
      'requestBody',
      'providerUser',
    ]) {
      expect(context, isNot(contains(forbidden)));
    }
  });
}
