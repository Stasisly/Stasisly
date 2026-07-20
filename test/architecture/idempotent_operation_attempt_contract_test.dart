import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const attemptContract = 'lib/core/idempotency/operation_attempt_id.dart';
  const canonicalInputs =
      'lib/features/conversations/application/inputs/conversation_inputs.dart';
  const transitionalAdapter =
      'lib/features/conversations/data/adapters/'
      'transitional_conversation_repository_adapter.dart';
  const sessionDatasource =
      'lib/features/chat_sessions/data/datasources/'
      'local_http_own_chat_sessions_datasource.dart';
  const messageDatasource =
      'lib/features/chat_messages/data/datasources/'
      'local_http_own_chat_messages_datasource.dart';
  const effectRepositoryPaths = [
    'lib/features/chat_sessions/data/repositories/validating_own_chat_sessions_repository.dart',
    'lib/features/chat_sessions/data/repositories/backend_blocked_own_chat_sessions_repository.dart',
    'lib/features/chat_sessions/data/repositories/demo_own_chat_sessions_repository.dart',
    'lib/features/chat_messages/data/repositories/backend_blocked_own_chat_messages_repository.dart',
    'lib/features/chat_messages/data/repositories/demo_own_chat_messages_repository.dart',
  ];

  test('effect inputs require the neutral operation attempt contract', () {
    final source = File(canonicalInputs).readAsStringSync();

    expect(source, contains('required this.operationAttemptId'));
    expect(
      RegExp(r'required this\.operationAttemptId').allMatches(source),
      hasLength(2),
    );
    for (final forbidden in [
      'ownerSubjectId',
      'author',
      'role',
      'agentId',
      'correlationId',
      'idempotencyKey',
    ]) {
      expect(source, isNot(contains(forbidden)));
    }
  });

  test('attempt contract is provider-neutral and redacts display', () {
    final source = File(attemptContract).readAsStringSync();

    expect(source, contains(r"r'^[A-Za-z0-9._~-]{16,128}$'"));
    expect(source, contains('OperationAttemptId([redacted])'));
    for (final forbidden in [
      'flutter/',
      'dio',
      'supabase',
      'http',
      'userId',
      'token',
      'correlation',
      'DateTime.now',
      'print(',
      'log(',
    ]) {
      expect(source.toLowerCase(), isNot(contains(forbidden.toLowerCase())));
    }
  });

  test('adapter passes attempts unchanged and never creates replacements', () {
    final source = File(transitionalAdapter).readAsStringSync();

    expect(
      RegExp(
        r'operationAttemptId:\s*input\.operationAttemptId',
      ).allMatches(source),
      hasLength(2),
    );
    expect(source, isNot(contains('OperationAttemptIdFactory')));
    expect(source, isNot(contains('SecureOperationAttemptIdFactory')));
    expect(source, isNot(contains('operationAttemptIds.create()')));
  });

  test(
    'repositories cannot generate, derive or replace operation attempts',
    () {
      for (final path in effectRepositoryPaths) {
        final source = File(path).readAsStringSync();

        expect(
          source,
          isNot(contains('OperationAttemptIdFactory')),
          reason: path,
        );
        expect(
          source,
          isNot(contains('SecureOperationAttemptIdFactory')),
          reason: path,
        );
        expect(source, isNot(contains('DateTime.now')), reason: path);
        expect(source, isNot(contains('correlationId')), reason: path);
        expect(source, isNot(contains('conversationId.value')), reason: path);
        expect(source, isNot(contains('sessionId.value')), reason: path);
      }
    },
  );

  test('datasources only map supplied attempts to Idempotency-Key', () {
    for (final path in [sessionDatasource, messageDatasource]) {
      final source = File(path).readAsStringSync();

      expect(source, contains("'Idempotency-Key': idempotencyKey.value"));
      expect(
        source,
        contains('required OperationAttemptId operationAttemptId'),
      );
      expect(source, isNot(contains('OperationAttemptIdFactory')));
      expect(source, isNot(contains('SecureOperationAttemptIdFactory')));
      expect(source, isNot(contains('operationAttemptIds.create()')));
      expect(source, isNot(contains('DateTime.now')));
      expect(source, isNot(contains('correlationId')));
    }
  });

  test('widgets never create or transport operation attempts', () {
    final widgetFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where(
          (file) =>
              file.path.endsWith('.dart') &&
              file.path.contains('/presentation/widgets/'),
        );

    for (final file in widgetFiles) {
      final source = file.readAsStringSync();
      expect(source, isNot(contains('OperationAttemptId')), reason: file.path);
      expect(source, isNot(contains('Idempotency-Key')), reason: file.path);
    }
  });
}
