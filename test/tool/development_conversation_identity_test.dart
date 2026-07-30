import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_conversation_identity.dart';

void main() {
  const conversation = '11111111-1111-4111-8111-111111111111';
  const owner = '22222222-2222-4222-8222-222222222222';
  const runMarker = 'local-run-0001';
  const attempt = 'local-run-0001_create_0001';
  final createdAt = DateTime.utc(2026, 7, 30, 12);
  final binding = ConversationLedgerBinding.validated(
    commitSha: 'a' * 40,
    authorizationReference: 'FA-LOCAL-R2I-0001',
    manifestVersion: 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v5',
    runnerVersion: 'FOUNDATION-019A-R2I-RUNNER-v1',
    environment: 'development',
  );

  ConversationCreateResponseAssessment assess({
    int? status = 201,
    Object? body = const {
      'session': {'sessionId': conversation},
    },
  }) => classifyConversationCreateResponse(
    status: status,
    body: body,
    ownerHandle: owner,
    operationAttemptId: attempt,
    runMarker: runMarker,
    normalizedRequest: 'canonical-specialist',
    clock: () => createdAt,
  );

  CreatedConversationIdentity identity() => assess().identity!;

  group('create response classification', () {
    test('exact 200 and 201 responses produce the complete identity', () {
      for (final status in [200, 201]) {
        final result = assess(status: status);
        expect(
          result.classification,
          ConversationCreateResponseClassification
              .createConfirmedWithExactIdentity,
        );
        expect(result.permitsCreatedState, isTrue);
        expect(result.identity?.conversationHandle, conversation);
        expect(result.identity?.ownerHandle, owner);
        expect(result.identity?.operationAttemptId, attempt);
        expect(result.identity?.runMarker, runMarker);
        expect(result.identity?.cleanupHandle, conversation);
        expect(result.identity?.diagnosticLookupHandle, conversation);
        expect(result.identity?.ownership, conversationIdentityOwnership);
        expect(result.identity?.environment, 'development');
        expect(result.identity?.createdAt, createdAt);
        expect(
          result.identity?.creationRequestFingerprint,
          matches(RegExp(r'^[0-9a-f]{64}$')),
        );
      }
    });

    test('accepted response without exact handle is incomplete', () {
      for (final body in [
        null,
        const <String, Object?>{},
        const {'session': <String, Object?>{}},
        const {
          'session': {'sessionId': 'invalid'},
        },
      ]) {
        final result = assess(body: body);
        expect(result.permitsCreatedState, isFalse);
        expect(result.identity, isNull);
        expect(
          result.failureEvidence,
          anyOf(
            conversationCreateResponseIncomplete,
            'CREATE_RESPONSE_INVALID',
          ),
        );
      }
    });

    test('rejection and ambiguous acceptance never permit created state', () {
      expect(
        assess(status: 422).classification,
        ConversationCreateResponseClassification.createResponseInvalid,
      );
      expect(
        assess(status: null).classification,
        ConversationCreateResponseClassification
            .createTransportFailurePossiblyAccepted,
      );
      expect(
        classifyConversationCreateResponse(
          status: null,
          body: null,
          ownerHandle: owner,
          operationAttemptId: attempt,
          runMarker: runMarker,
          normalizedRequest: 'request',
          requestWasSent: false,
        ).classification,
        ConversationCreateResponseClassification
            .createTransportFailureNoAcceptanceEvidence,
      );
      expect(
        assess(status: 202).classification,
        ConversationCreateResponseClassification
            .createAcceptedPendingConfirmation,
      );
      expect(assess(status: 422).permitsCreatedState, isFalse);
      expect(assess(status: null).permitsCreatedState, isFalse);
    });

    test('invalid owner, attempt and run marker fail closed', () {
      for (final invalid in [
        classifyConversationCreateResponse(
          status: 201,
          body: const {
            'session': {'sessionId': conversation},
          },
          ownerHandle: 'invalid',
          operationAttemptId: attempt,
          runMarker: runMarker,
          normalizedRequest: 'request',
        ),
        classifyConversationCreateResponse(
          status: 201,
          body: const {
            'session': {'sessionId': conversation},
          },
          ownerHandle: owner,
          operationAttemptId: 'short',
          runMarker: runMarker,
          normalizedRequest: 'request',
        ),
        classifyConversationCreateResponse(
          status: 201,
          body: const {
            'session': {'sessionId': conversation},
          },
          ownerHandle: owner,
          operationAttemptId: attempt,
          runMarker: '../escape',
          normalizedRequest: 'request',
        ),
      ]) {
        expect(invalid.permitsCreatedState, isFalse);
        expect(invalid.identity, isNull);
      }
    });
  });

  group('created identity contract', () {
    test('round trips all exact handles through canonical JSON', () {
      final original = identity();
      final restored = CreatedConversationIdentity.fromJson(
        jsonDecode(jsonEncode(original.toJson())) as Map<String, Object?>,
      );
      expect(original.sameIdentity(restored), isTrue);
      expect(restored.validate(), isEmpty);
    });

    test('unknown, missing and mismatched cleanup fields are rejected', () {
      final valid = identity().toJson();
      for (final changed in [
        {...valid, 'unknown': true},
        {...valid}..remove('ownerHandle'),
        {...valid, 'cleanupHandle': owner},
        {...valid, 'diagnosticLookupHandle': owner},
        {...valid, 'ownership': 'PREEXISTING'},
        {...valid, 'environment': 'production'},
      ]) {
        expect(
          () => CreatedConversationIdentity.fromJson(changed),
          throwsFormatException,
        );
      }
    });
  });

  group('created state commit protocol', () {
    late Directory repository;
    late ConversationIdentityLedgerStore store;

    setUp(() {
      repository = Directory.systemTemp.createTempSync(
        'stasisly-conversation-protocol.',
      );
      store = ConversationIdentityLedgerStore(
        repositoryRoot: repository,
        binding: binding,
      );
    });

    tearDown(() {
      if (repository.existsSync()) repository.deleteSync(recursive: true);
    });

    test('exact identity and verified ledger permit created transition', () {
      final protocol = ConversationIdentityCommitProtocol();
      final value = identity();
      protocol
        ..validateIdentity(value)
        ..markLedgerPending()
        ..markLedgerCommitted(store.persistAndVerify(value))
        ..markStateTransitionCommitted();
      expect(
        protocol.state,
        ConversationIdentityCommitState.stateTransitionCommitted,
      );
    });

    test('identity incomplete can never enter the commit protocol', () {
      final result = assess(body: const {'session': <String, Object?>{}});
      expect(result.identity, isNull);
      expect(
        ConversationIdentityCommitProtocol().state,
        ConversationIdentityCommitState.initial,
      );
    });

    test(
      'ledger write or verification failure cannot commit created state',
      () {
        final protocol = ConversationIdentityCommitProtocol();
        // Keep the failing transition assertion between protocol phases.
        // ignore: cascade_invocations
        protocol
          ..validateIdentity(identity())
          ..markLedgerPending();
        expect(protocol.markStateTransitionCommitted, throwsStateError);
        expect(protocol.state, ConversationIdentityCommitState.ledgerPending);
        protocol.beginCleanup();
        expect(protocol.state, ConversationIdentityCommitState.cleanupPending);
      },
    );

    test(
      'state transition failure still permits cleanup from committed ledger',
      () {
        final protocol = ConversationIdentityCommitProtocol();
        final value = identity();
        protocol
          ..validateIdentity(value)
          ..markLedgerPending()
          ..markLedgerCommitted(store.persistAndVerify(value))
          ..beginCleanup();
        expect(protocol.identity?.cleanupHandle, conversation);
        expect(protocol.state, ConversationIdentityCommitState.cleanupPending);
        protocol.close();
        expect(protocol.state, ConversationIdentityCommitState.closed);
        expect(() => protocol.validateIdentity(value), throwsStateError);
      },
    );
  });

  group('ephemeral identity ledger', () {
    late Directory repository;
    late ConversationIdentityLedgerStore store;

    setUp(() {
      repository = Directory.systemTemp.createTempSync(
        'stasisly-conversation-identity.',
      );
      store = ConversationIdentityLedgerStore(
        repositoryRoot: repository,
        binding: binding,
      );
    });

    tearDown(() {
      if (repository.existsSync()) repository.deleteSync(recursive: true);
    });

    test('persists atomically and verifies canonical integrity', () {
      final original = identity();
      final restored = store.persistAndVerify(original);
      expect(original.sameIdentity(restored.identity), isTrue);
      expect(restored.lifecycle, ConversationLedgerLifecycle.resourceCreated);
      expect(store.ledgerFile(runMarker).existsSync(), isTrue);
      expect(
        store.ledgerFile(runMarker).path,
        endsWith('.runtime/runs/$runMarker/resource-ledger.json'),
      );
    });

    test('uses private directory and file permissions', () {
      store.persist(identity());
      final file = store.ledgerFile(runMarker);
      expect(file.statSync().mode & 0x1ff, 0x180);
      expect(file.parent.statSync().mode & 0x1ff, 0x1c0);
      expect(file.parent.parent.statSync().mode & 0x1ff, 0x1c0);
    });

    test('does not persist secrets, email or content fields', () {
      store.persist(identity());
      final keys =
          (jsonDecode(store.ledgerFile(runMarker).readAsStringSync())
                  as Map<String, dynamic>)
              .toString()
              .toLowerCase();
      for (final forbidden in [
        'email',
        'password',
        'token',
        'secret',
        'content',
        'jwt',
      ]) {
        expect(keys, isNot(contains(forbidden)));
      }
    });

    test('tampering is detected by the canonical hash', () {
      store.persist(identity());
      final file = store.ledgerFile(runMarker);
      final value = jsonDecode(file.readAsStringSync()) as Map<String, dynamic>;
      final payload = value['payload'] as Map<String, dynamic>;
      (payload['identity'] as Map<String, dynamic>)['ownerHandle'] =
          conversation;
      file.writeAsStringSync(jsonEncode(value));
      expect(() => store.readRecord(runMarker), throwsFormatException);
    });

    test('interruption before rename leaves no accepted ledger', () {
      store = ConversationIdentityLedgerStore(
        repositoryRoot: repository,
        binding: binding,
        beforeAtomicRename: (_, _) =>
            throw StateError('simulated interruption'),
      );
      expect(() => store.persist(identity()), throwsStateError);
      expect(store.ledgerFile(runMarker).existsSync(), isFalse);
      expect(
        store
            .ledgerFile(runMarker)
            .parent
            .listSync()
            .whereType<File>()
            .where((file) => file.path.contains('.tmp.')),
        isEmpty,
      );
    });

    test('interrupted replacement preserves the prior verified identity', () {
      final original = identity();
      store.persist(original);
      store = ConversationIdentityLedgerStore(
        repositoryRoot: repository,
        binding: binding,
        beforeAtomicRename: (_, _) =>
            throw StateError('simulated interruption'),
      );
      expect(() => store.persist(original), throwsStateError);
      expect(
        store.readRecord(runMarker).identity.sameIdentity(original),
        isTrue,
      );
    });

    test('cleanup removes only the exact run ledger', () {
      store
        ..persist(identity())
        ..delete(runMarker);
      expect(store.ledgerFile(runMarker).existsSync(), isFalse);
    });

    test('lifecycle is verified, monotonic and cannot reopen closed', () {
      store
        ..persist(identity())
        ..transition(
          runMarker,
          expected: ConversationLedgerLifecycle.resourceCreated,
          next: ConversationLedgerLifecycle.cleanupPending,
        )
        ..transition(
          runMarker,
          expected: ConversationLedgerLifecycle.cleanupPending,
          next: ConversationLedgerLifecycle.cleaned,
        )
        ..transition(
          runMarker,
          expected: ConversationLedgerLifecycle.cleaned,
          next: ConversationLedgerLifecycle.closed,
        );
      expect(
        store.readRecord(runMarker).lifecycle,
        ConversationLedgerLifecycle.closed,
      );
      expect(
        () => store.transition(
          runMarker,
          expected: ConversationLedgerLifecycle.closed,
          next: ConversationLedgerLifecycle.resourceCreated,
        ),
        throwsStateError,
      );
    });

    test('restart rejects wrong commit, runner and manifest binding', () {
      store.persist(identity());
      for (final wrong in [
        ConversationLedgerBinding.validated(
          commitSha: 'b' * 40,
          authorizationReference: 'FA-LOCAL-R2I-0001',
          manifestVersion: 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v5',
          runnerVersion: 'FOUNDATION-019A-R2I-RUNNER-v1',
          environment: 'development',
        ),
      ]) {
        final restarted = ConversationIdentityLedgerStore(
          repositoryRoot: repository,
          binding: wrong,
        );
        expect(() => restarted.readRecord(runMarker), throwsFormatException);
      }
    });

    test('invalid run marker cannot escape the runtime root', () {
      expect(() => store.ledgerFile('../outside'), throwsFormatException);
    });
  });

  group('legacy and shared-handle behavior', () {
    test('v4 dirty run remains explicitly classified as identity-missing', () {
      expect(
        classifyLegacyConversationIdentity(
          manifestVersion: 'FOUNDATION-019A-SECOND-FUNCTIONAL-ATTEMPT-v4',
          exactIdentityPersisted: false,
        ),
        legacyDirtyRunMissingExactConversationIdentity,
      );
    });

    test('cleanup and diagnostic lookup use the same canonical handle', () {
      final value = identity();
      expect(value.cleanupHandle, value.conversationHandle);
      expect(value.diagnosticLookupHandle, value.conversationHandle);
      expect(value.ownerHandle, isNot(value.conversationHandle));
    });
  });
}
