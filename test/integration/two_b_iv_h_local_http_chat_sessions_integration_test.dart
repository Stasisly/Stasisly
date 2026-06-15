import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/chat_sessions/data/datasources/local_http_own_chat_sessions_datasource.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_only_host_policy.dart';
import 'package:stasisly/features/chat_sessions/data/local/local_session_token_provider.dart';
import 'package:stasisly/features/chat_sessions/data/local/own_chat_sessions_http_transport.dart';
import 'package:stasisly/features/chat_sessions/data/repositories/validating_own_chat_sessions_repository.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session.dart';
import 'package:stasisly/features/chat_sessions/domain/entities/own_chat_session_results.dart';

void main() {
  const hasIntegrationEnvironment =
      bool.hasEnvironment('STASISLY_2B_IV_H_API_URL') &&
      bool.hasEnvironment('STASISLY_2B_IV_H_ACCESS_TOKEN') &&
      bool.hasEnvironment('STASISLY_2B_IV_H_SELECTABLE_ID');

  if (!hasIntegrationEnvironment) {
    test(
      '2B-IV-H local integration requires the approved local harness',
      () {},
      skip: 'Run supabase/tests/2b_iv_h_local_http_integration_test.sh',
    );
    return;
  }

  late ValidatingOwnChatSessionsRepository repository;

  setUpAll(() {
    final baseUri = Uri.parse(_requiredEnv('STASISLY_2B_IV_H_API_URL'));
    repository = ValidatingOwnChatSessionsRepository(
      source: LocalHttpOwnChatSessionsDataSource(
        baseUri: baseUri,
        hostPolicy: const LocalOnlyHostPolicy(localValidationEnabled: true),
        tokenProvider: const _TestLocalSessionTokenProvider(),
        transport: DioOwnChatSessionsHttpTransport(dio: Dio()),
      ),
    );
  });

  test('create-list-archive-list works against local Edge Functions', () async {
    final selectableId = _requiredEnv('STASISLY_2B_IV_H_SELECTABLE_ID');

    final created = await repository.createOwnChatSession(
      selectableSpecialistId: selectableId,
    );
    expect(created, isA<CreateOwnChatSessionSuccess>());
    final createdSession = (created as CreateOwnChatSessionSuccess).session;
    expect(createdSession.selectableSpecialist.id, selectableId);
    expect(createdSession.status, ChatSessionStatus.active);
    expect(createdSession.messageCount, 0);

    final activeBefore = await repository.listOwnChatSessions();
    expect(activeBefore, isA<ListOwnChatSessionsSuccess>());
    final activeBeforeItems =
        (activeBefore as ListOwnChatSessionsSuccess).page.items;
    expect(
      activeBeforeItems.map((session) => session.sessionId),
      contains(createdSession.sessionId),
    );

    final archived = await repository.archiveOwnChatSession(
      sessionId: createdSession.sessionId,
    );
    expect(archived, isA<ArchiveOwnChatSessionSuccess>());
    expect(
      (archived as ArchiveOwnChatSessionSuccess).session.status,
      ChatSessionStatus.archived,
    );
    expect(archived.session.sessionId, createdSession.sessionId);

    final activeAfter = await repository.listOwnChatSessions();
    expect(activeAfter, isA<ListOwnChatSessionsSuccess>());
    final activeAfterItems =
        (activeAfter as ListOwnChatSessionsSuccess).page.items;
    expect(
      activeAfterItems.map((session) => session.sessionId),
      isNot(contains(createdSession.sessionId)),
    );

    final archivedAfter = await repository.listOwnChatSessions(
      status: ChatSessionStatusFilter.archived,
    );
    expect(archivedAfter, isA<ListOwnChatSessionsSuccess>());
    final archivedItems =
        (archivedAfter as ListOwnChatSessionsSuccess).page.items;
    final archivedSession = archivedItems.singleWhere(
      (session) => session.sessionId == createdSession.sessionId,
    );
    expect(archivedSession.status, ChatSessionStatus.archived);
    expect(archivedSession.lastMessageAt, createdSession.lastMessageAt);
  });

  test('missing token fails before HTTP transport', () async {
    final blocked = ValidatingOwnChatSessionsRepository(
      source: LocalHttpOwnChatSessionsDataSource(
        baseUri: Uri.parse(_requiredEnv('STASISLY_2B_IV_H_API_URL')),
        hostPolicy: const LocalOnlyHostPolicy(localValidationEnabled: true),
        tokenProvider: const _StaticTokenProvider(null),
        transport: _FailingTransport(),
      ),
    );

    expect(
      await blocked.listOwnChatSessions(),
      const ListOwnChatSessionsFailure(
        OwnChatSessionsFailureType.unauthenticated,
      ),
    );
  });

  test('remote host fails before HTTP transport', () async {
    final blocked = ValidatingOwnChatSessionsRepository(
      source: LocalHttpOwnChatSessionsDataSource(
        baseUri: Uri.parse('https://project.supabase.co'),
        hostPolicy: const LocalOnlyHostPolicy(localValidationEnabled: true),
        tokenProvider: const _TestLocalSessionTokenProvider(),
        transport: _FailingTransport(),
      ),
    );

    expect(
      await blocked.createOwnChatSession(
        selectableSpecialistId: _requiredEnv('STASISLY_2B_IV_H_SELECTABLE_ID'),
      ),
      const CreateOwnChatSessionFailure(
        OwnChatSessionsFailureType.backendBlocked,
      ),
    );
  });
}

String _requiredEnv(String key) {
  final value = switch (key) {
    'STASISLY_2B_IV_H_API_URL' => const String.fromEnvironment(
      'STASISLY_2B_IV_H_API_URL',
    ),
    'STASISLY_2B_IV_H_ACCESS_TOKEN' => const String.fromEnvironment(
      'STASISLY_2B_IV_H_ACCESS_TOKEN',
    ),
    'STASISLY_2B_IV_H_SELECTABLE_ID' => const String.fromEnvironment(
      'STASISLY_2B_IV_H_SELECTABLE_ID',
    ),
    _ => '',
  };
  if (value.isEmpty) {
    throw StateError('$key is required for 2B-IV-H local integration.');
  }
  return value;
}

class _TestLocalSessionTokenProvider implements LocalSessionTokenProvider {
  const _TestLocalSessionTokenProvider();

  @override
  Future<String?> readLocalSessionToken() async {
    return _requiredEnv('STASISLY_2B_IV_H_ACCESS_TOKEN');
  }
}

class _StaticTokenProvider implements LocalSessionTokenProvider {
  const _StaticTokenProvider(this.token);

  final String? token;

  @override
  Future<String?> readLocalSessionToken() async => token;
}

class _FailingTransport implements OwnChatSessionsHttpTransport {
  @override
  Future<OwnChatSessionsHttpResponse> send(OwnChatSessionsHttpRequest request) {
    throw StateError('Transport must not be called.');
  }
}
