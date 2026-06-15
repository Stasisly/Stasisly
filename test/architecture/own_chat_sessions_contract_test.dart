import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final featureFiles = Directory('lib/features/chat_sessions')
      .listSync(recursive: true)
      .whereType<File>()
      .where((file) => file.path.endsWith('.dart'))
      .toList(growable: false);

  test(
    'sessions feature never uses Supabase or forbidden runtime coupling',
    () {
      for (final file in featureFiles) {
        final source = file.readAsStringSync();
        for (final forbidden in [
          'supabase_flutter',
          'Supabase.instance',
          'functions.invoke',
          'package:http/',
          'dart:io',
          'dart:html',
          'service_role',
          'messages',
        ]) {
          expect(source, isNot(contains(forbidden)), reason: file.path);
        }
      }
    },
  );

  test(
    'real HTTP dependency and function paths stay inside local data layer',
    () {
      for (final file in featureFiles) {
        final source = file.readAsStringSync();
        if (source.contains('package:dio/')) {
          expect(
            file.path,
            endsWith('data/local/own_chat_sessions_http_transport.dart'),
          );
        }
        if (source.contains('/functions/v1/')) {
          expect(
            file.path,
            endsWith(
              'data/datasources/local_http_own_chat_sessions_datasource.dart',
            ),
          );
        }
      }
    },
  );

  test('local datasource cannot reference demo fallback', () {
    final source = File(
      'lib/features/chat_sessions/data/datasources/'
      'local_http_own_chat_sessions_datasource.dart',
    ).readAsStringSync();

    expect(source, isNot(contains('DemoOwnChatSessionsRepository')));
    expect(source, isNot(contains('CreateOwnChatSessionDemo')));
    expect(source, isNot(contains('ListOwnChatSessionsDemo')));
    expect(source, isNot(contains('ArchiveOwnChatSessionDemo')));
  });

  test('local HTTP layer disables redirects and contains no token logging', () {
    final localFiles = Directory('lib/features/chat_sessions/data/local')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'))
        .toList(growable: false);
    final transport = File(
      'lib/features/chat_sessions/data/local/'
      'own_chat_sessions_http_transport.dart',
    ).readAsStringSync();

    expect(transport, contains('followRedirects: false'));
    expect(transport, contains('maxRedirects: 0'));
    for (final file in localFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in ['print(', 'debugPrint(', 'log(', 'developer.']) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('public domain and repository contracts contain no internal ids', () {
    final publicFiles = [
      File('lib/features/chat_sessions/domain/entities/own_chat_session.dart'),
      File(
        'lib/features/chat_sessions/domain/entities/'
        'own_chat_session_results.dart',
      ),
      File(
        'lib/features/chat_sessions/domain/repositories/'
        'own_chat_sessions_repository.dart',
      ),
      File(
        'lib/features/chat_sessions/data/contracts/'
        'own_chat_sessions_contract_source.dart',
      ),
    ];

    for (final file in publicFiles) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'userId',
        'user_id',
        'specialistId',
        'specialist_id',
        'internalSpecialistId',
        'ownerId',
        'authUserId',
        'backendUserId',
        'prompt_template',
        'access_tier',
        'availability_status',
        'roles',
        'permissions',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('repository contract accepts only approved operation inputs', () {
    final source = File(
      'lib/features/chat_sessions/domain/repositories/'
      'own_chat_sessions_repository.dart',
    ).readAsStringSync();

    expect(source, contains('required String selectableSpecialistId'));
    expect(source, contains('required String sessionId'));
    expect(source, contains('ChatSessionStatusFilter status'));
    expect(source, contains('int limit = 20'));
    expect(source, contains('String? cursor'));
  });
}
