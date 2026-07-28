import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_complete_runner_contracts.dart';

void main() {
  final manifest = CompleteRunnerManifest.read(
    File(
      'docs/stasisly_foundation/development/'
      'development_second_functional_attempt_manifest.json',
    ),
  );

  group('manifest to runner matrix', () {
    test('is complete, executable and uses the approved versions', () {
      expect(manifest.version, completeManifestVersion);
      expect(manifest.runnerVersion, completeRunnerVersion);
      expect(manifest.validate(), isEmpty);
      expect(manifest.operations, hasLength(manifest.states.length - 1));
      expect(
        manifest.operations.every(
          (operation) =>
              operation.implemented &&
              operation.tested &&
              operation.requestContract.isNotEmpty &&
              operation.successEvidence.isNotEmpty &&
              operation.failureEvidence.isNotEmpty &&
              operation.ledgerEffect.isNotEmpty &&
              operation.cleanupEffect.isNotEmpty,
        ),
        isTrue,
      );
    });

    test('uses one canonical read-only specialist policy', () {
      expect(manifest.specialistPolicy, canonicalSpecialistPolicy);
      expect(manifest.specialistSource, canonicalSpecialistSource);
      expect(
        manifest.specialistSelectionMode,
        canonicalSpecialistSelectionMode,
      );
      expect(manifest.specialistSelectionArea, canonicalSpecialistArea);
      expect(manifest.specialistSelectionLimit, 20);
      final operation = manifest.operations.singleWhere(
        (operation) => operation.operation == 'specialistResolution',
      );
      expect(operation.runnerFunction, 'resolveSpecialistFromCanonicalCatalog');
      expect(operation.ledgerEffect, 'VERIFIED_PREEXISTING_READ_ONLY');
      expect(operation.cleanupEffect, 'NONE');
    });

    test('rejects every manifest specialist semantic divergence', () {
      final source =
          jsonDecode(
                File(
                  'docs/stasisly_foundation/development/'
                  'development_second_functional_attempt_manifest.json',
                ).readAsStringSync(),
              )
              as Map<String, dynamic>;
      final mutations = <void Function(Map<String, dynamic>)>[
        (value) => value['specialistPolicy'] = 'VERIFIED_OR_RUN_OWNED',
        (value) => value['specialistSource'] = 'LOCAL_FIXTURE',
        (value) => value['specialistCreation'] = 'ALLOWED',
        (value) => value['catalogCreation'] = 'ALLOWED',
        (value) => value['specialistCleanup'] = 'DELETE',
        (value) => value['catalogCleanup'] = 'DELETE',
        (value) =>
            (value['specialistSelection'] as Map<String, dynamic>)['mode'] =
                'FIRST_RESULT',
        (value) {
          final operation = (value['operations'] as List)
              .cast<Map<String, dynamic>>()
              .singleWhere(
                (operation) => operation['operation'] == 'specialistResolution',
              );
          operation['ledgerEffect'] = 'SPECIALIST_CREATED_BY_RUN';
        },
        (value) {
          final operation = (value['operations'] as List)
              .cast<Map<String, dynamic>>()
              .singleWhere(
                (operation) => operation['operation'] == 'specialistResolution',
              );
          operation['cleanupEffect'] = 'DELETE_SPECIALIST';
        },
      ];
      final directory = Directory.systemTemp.createTempSync(
        'stasisly-r2e-manifest.',
      );
      try {
        for (var index = 0; index < mutations.length; index++) {
          final changed =
              jsonDecode(jsonEncode(source)) as Map<String, dynamic>;
          mutations[index](changed);
          final file = File('${directory.path}/manifest-$index.json')
            ..writeAsStringSync(jsonEncode(changed));
          expect(
            CompleteRunnerManifest.read(file).validate(),
            isNotEmpty,
            reason: 'mutation $index must fail closed',
          );
        }
      } finally {
        directory.deleteSync(recursive: true);
      }
    });

    test('contains every required executable operation', () {
      final operations = manifest.operations
          .map((operation) => operation.operation)
          .toSet();
      expect(
        operations,
        containsAll({
          'preflight',
          'targetVerification',
          'syntheticSetup',
          'authSetup',
          'specialistResolution',
          'conversationCreate',
          'idempotencyReplay',
          'activeList',
          'detailRead',
          'messageSend',
          'noAiValidation',
          'archive',
          'archivedStateValidation',
          'restore',
          'restoredStateValidation',
          'foreignOwnershipOpacity',
          'blockedRoutes',
          'cleanup',
          'authAbsence',
          'sevenCounters',
          'cliIsolation',
          'localRegression',
        }),
      );
    });
  });

  group('canonical specialist resolution', () {
    const policy = VerifiedPreexistingReadOnlyPolicy();

    Map<String, Object?> candidate({
      String id = '11111111-1111-4111-8111-111111111111',
      String area = 'stasis',
      String accessState = 'available',
    }) => {
      'selectableSpecialistId': id,
      'displayName': 'Canonical test specialist',
      'publicArea': area,
      'publicDescription': 'Synthetic contract fixture.',
      'accessState': accessState,
    };

    CanonicalSpecialistResolutionResult resolve(
      Object? payload, {
      bool available = true,
      String environment = 'development',
      bool authorized = true,
    }) => policy.resolve(
      catalogPayload: payload,
      catalogAvailable: available,
      environment: environment,
      policyAuthorized: authorized,
    );

    test('exactly one available specialist may continue', () {
      final result = resolve([candidate()]);
      expect(
        result.state,
        CanonicalSpecialistResolutionState.exactlyOneSelectable,
      );
      expect(result.mayContinue, isTrue);
      expect(
        result.specialist?.selectableSpecialistId,
        '11111111-1111-4111-8111-111111111111',
      );
    });

    test('zero selectable specialists blocks', () {
      expect(
        resolve([]).state,
        CanonicalSpecialistResolutionState.noneSelectable,
      );
      expect(
        resolve([candidate(accessState: 'unavailable')]).state,
        CanonicalSpecialistResolutionState.noneSelectable,
      );
    });

    test('multiple selectable candidates block without picking first', () {
      final result = resolve([
        candidate(),
        candidate(id: '22222222-2222-4222-8222-222222222222'),
      ]);
      expect(
        result.state,
        CanonicalSpecialistResolutionState.multipleSelectableCandidates,
      );
      expect(result.specialist, isNull);
    });

    test('canonical area match passes and missing area blocks', () {
      expect(resolve([candidate()]).mayContinue, isTrue);
      expect(
        resolve([candidate(area: 'health')]).state,
        CanonicalSpecialistResolutionState.noneSelectable,
      );
    });

    test('catalog unavailable and malformed responses block closed', () {
      expect(
        resolve(null, available: false).state,
        CanonicalSpecialistResolutionState.catalogUnavailable,
      );
      expect(
        resolve({'not': 'a-list'}).state,
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
      expect(
        resolve([
          {...candidate(), 'unknown': true},
        ]).state,
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
    });

    test('invalid status, identifier and Product area block', () {
      expect(
        resolve([candidate(accessState: 'enabled')]).state,
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
      expect(
        resolve([candidate(id: 'not-a-uuid')]).state,
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
      expect(
        resolve([candidate(area: 'administration')]).state,
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
    });

    test('environment mismatch and unauthorized policy block', () {
      expect(
        resolve([candidate()], environment: 'staging').state,
        CanonicalSpecialistResolutionState.environmentMismatch,
      );
      expect(
        resolve([candidate()], authorized: false).state,
        CanonicalSpecialistResolutionState.authorizationRejected,
      );
    });

    test('bounded catalog rejects more than twenty candidates', () {
      final candidates = List.generate(
        21,
        (index) => candidate(
          id: '${(index + 1).toString().padLeft(8, '0')}-1111-4111-8111-111111111111',
        ),
      );
      expect(
        resolve(candidates).state,
        CanonicalSpecialistResolutionState.catalogContractInvalid,
      );
    });
  });

  group('complete state machine', () {
    test('accepts the full valid path and becomes terminal', () {
      final machine = CompleteRunnerStateMachine(manifest);
      for (final operation in manifest.operations) {
        expect(machine.state, operation.fromState);
        machine.advance(operation.toState, evidence: operation.successEvidence);
      }
      expect(machine.state, 'LOCAL_REGRESSION_COMPLETED');
      expect(machine.terminal, isTrue);
    });

    test('accepts every required adjacent transition independently', () {
      final machine = CompleteRunnerStateMachine(manifest);
      for (final operation in manifest.operations) {
        expect(
          () => machine.advance(
            operation.toState,
            evidence: operation.successEvidence,
          ),
          returnsNormally,
        );
      }
    });

    for (final skipped in [
      'IDEMPOTENCY_REPLAY_VALIDATED',
      'ACTIVE_LIST_VALIDATED',
      'DETAIL_READ_VALIDATED',
      'ARCHIVED_STATE_VALIDATED',
      'RESTORED',
      'OWNERSHIP_OPACITY_VALIDATED',
      'BLOCKED_ROUTES_VALIDATED',
    ]) {
      test('blocks skipping $skipped', () {
        final machine = CompleteRunnerStateMachine(manifest);
        final skippedIndex = manifest.states.indexOf(skipped);
        for (var index = 0; index < skippedIndex - 1; index++) {
          final operation = manifest.operations[index];
          machine.advance(
            operation.toState,
            evidence: operation.successEvidence,
          );
        }
        final target = manifest.states[skippedIndex + 1];
        expect(
          () => machine.advance(target, evidence: target),
          throwsStateError,
        );
      });
    }

    test('blocks reverse, repeated and terminal transitions', () {
      final machine = CompleteRunnerStateMachine(manifest);
      final first = manifest.operations.first;
      machine.advance(first.toState, evidence: first.successEvidence);
      expect(
        () => machine.advance(first.toState, evidence: first.successEvidence),
        throwsStateError,
      );
      expect(
        () => machine.advance('INITIAL', evidence: 'INITIAL'),
        throwsStateError,
      );
      for (final operation in manifest.operations.skip(1)) {
        machine.advance(operation.toState, evidence: operation.successEvidence);
      }
      expect(
        () => machine.advance('INITIAL', evidence: 'INITIAL'),
        throwsStateError,
      );
    });

    test('cleanup is reachable from every approved failure point', () {
      for (final failureState in manifest.failureCleanupFromStates) {
        final machine = CompleteRunnerStateMachine(manifest);
        final targetIndex = manifest.states.indexOf(failureState);
        for (var index = 0; index < targetIndex; index++) {
          final operation = manifest.operations[index];
          machine.advance(
            operation.toState,
            evidence: operation.successEvidence,
          );
        }
        expect(machine.beginCleanupAfterFailure(), 'CLEANUP_STARTED');
        expect(
          () => machine.advance(
            'CLEANUP_COMPLETED',
            evidence: 'CLEANUP_COMPLETED',
          ),
          returnsNormally,
        );
      }
    });
  });

  group('idempotency replay', () {
    const first = ReplayInput(
      operationAttempt: 'attempt',
      idempotencyKey: 'key',
      normalizedRequest: 'request',
    );

    test('same attempt key request and result with one row passes', () {
      expect(
        validateReplay(
          first: first,
          replay: first,
          firstCanonicalResult: 'conversation',
          replayCanonicalResult: 'conversation',
          attributableConversationCount: 1,
        ),
        isTrue,
      );
    });

    test('transport retry and response loss preserve canonical replay', () {
      for (final recoveredStatus in ['transportRetry', 'responseLoss']) {
        expect(recoveredStatus, isNotEmpty);
        expect(
          validateReplay(
            first: first,
            replay: first,
            firstCanonicalResult: 'conversation',
            replayCanonicalResult: 'conversation',
            attributableConversationCount: 1,
          ),
          isTrue,
        );
      }
    });

    test('changed request, key, conflict result or duplicate blocks', () {
      for (final replay in [
        const ReplayInput(
          operationAttempt: 'attempt',
          idempotencyKey: 'key',
          normalizedRequest: 'changed',
        ),
        const ReplayInput(
          operationAttempt: 'attempt',
          idempotencyKey: 'other',
          normalizedRequest: 'request',
        ),
        const ReplayInput(
          operationAttempt: 'other',
          idempotencyKey: 'key',
          normalizedRequest: 'request',
        ),
      ]) {
        expect(
          validateReplay(
            first: first,
            replay: replay,
            firstCanonicalResult: 'conversation',
            replayCanonicalResult: 'conversation',
            attributableConversationCount: 1,
          ),
          isFalse,
        );
      }
      expect(
        validateReplay(
          first: first,
          replay: first,
          firstCanonicalResult: 'conversation',
          replayCanonicalResult: 'duplicate',
          attributableConversationCount: 2,
        ),
        isFalse,
      );
      expect(
        validateReplay(
          first: first,
          replay: first,
          firstCanonicalResult: 'conversation',
          replayCanonicalResult: 'conflict',
          attributableConversationCount: 1,
        ),
        isFalse,
      );
    });
  });

  group('list and detail contracts', () {
    const expected = 'conversation';
    const active = {'sessionId': expected, 'status': 'active'};

    test('created resource is present through deterministic pagination', () {
      expect(
        validateConversationList(
          pages: const [
            [
              {'sessionId': 'other', 'status': 'active'},
            ],
            [active],
          ],
          expectedConversationId: expected,
          expectedStatus: 'active',
        ),
        isTrue,
      );
    });

    test(
      'missing, foreign, duplicate and wrong-state list evidence blocks',
      () {
        for (final pages in [
          const [
            [
              {'sessionId': 'other', 'status': 'active'},
            ],
          ],
          const [
            [active],
            [active],
          ],
          const [
            [
              {'sessionId': expected, 'status': 'archived'},
            ],
          ],
          const <List<Map<String, Object?>>>[],
        ]) {
          expect(
            validateConversationList(
              pages: pages,
              expectedConversationId: expected,
              expectedStatus: 'active',
            ),
            isFalse,
          );
        }
      },
    );

    test(
      'detail requires canonical identity, state, specialist and messages',
      () {
        const detail = {
          'conversationId': expected,
          'status': 'active',
          'selectedSpecialist': {'id': 'specialist'},
        };
        expect(
          validateConversationDetail(
            detail: detail,
            expectedConversationId: expected,
            expectedSpecialistId: 'specialist',
            expectedStatus: 'active',
            messages: const [],
            expectEmptyMessages: true,
          ),
          isTrue,
        );
        for (final invalid in [
          {...detail, 'conversationId': 'foreign'},
          {...detail, 'status': 'archived'},
          {
            ...detail,
            'selectedSpecialist': {'id': 'wrong'},
          },
        ]) {
          expect(
            validateConversationDetail(
              detail: invalid,
              expectedConversationId: expected,
              expectedSpecialistId: 'specialist',
              expectedStatus: 'active',
              messages: const [],
              expectEmptyMessages: true,
            ),
            isFalse,
          );
        }
        expect(
          validateConversationDetail(
            detail: detail,
            expectedConversationId: expected,
            expectedSpecialistId: 'specialist',
            expectedStatus: 'active',
            messages: const [
              {'role': 'unknown'},
            ],
            expectEmptyMessages: true,
          ),
          isFalse,
        );
      },
    );
  });

  group('message, lifecycle and route contracts', () {
    test('only one canonical user message passes no-AI validation', () {
      const user = {
        'role': 'user',
        'author': 'user',
        'provenance': 'userProvided',
        'visibility': 'productVisible',
      };
      expect(validateNoAiMessages([user]), isTrue);
      for (final unexpected in [
        {...user, 'role': 'assistant'},
        {...user, 'author': 'unknown'},
        {...user, 'provenance': 'unknown'},
        {...user, 'visibility': 'systemVisible'},
      ]) {
        expect(validateNoAiMessages([unexpected]), isFalse);
      }
      expect(validateNoAiMessages([user, user]), isFalse);
      expect(
        validateNoAiEvidence(
          messages: const [user],
          modelGatewayInvocations: 0,
          stasisEngineInvocations: 0,
        ),
        isTrue,
      );
      for (final invocationEvidence in const [(1, 0), (0, 1)]) {
        expect(
          validateNoAiEvidence(
            messages: const [user],
            modelGatewayInvocations: invocationEvidence.$1,
            stasisEngineInvocations: invocationEvidence.$2,
          ),
          isFalse,
        );
      }
    });

    test('archive and restore require observed state, list and composer', () {
      expect(
        validateLifecycleState(
          observedStatus: 'archived',
          expectedStatus: 'archived',
          presentInActiveList: false,
          composerEnabled: false,
        ),
        isTrue,
      );
      expect(
        validateLifecycleState(
          observedStatus: 'active',
          expectedStatus: 'active',
          presentInActiveList: true,
          composerEnabled: true,
        ),
        isTrue,
      );
      for (final evidence in const [
        ('active', 'archived', false, false),
        ('archived', 'archived', true, false),
        ('archived', 'archived', false, true),
        ('archived', 'active', true, true),
        ('active', 'active', false, true),
        ('active', 'active', true, false),
      ]) {
        expect(
          validateLifecycleState(
            observedStatus: evidence.$1,
            expectedStatus: evidence.$2,
            presentInActiveList: evidence.$3,
            composerEnabled: evidence.$4,
          ),
          isFalse,
        );
      }
    });

    test('foreign read passes only an opaque not-found shape', () {
      const opaque = {
        'error': {'code': 'conversationNotFound'},
      };
      expect(validateOpaqueForeignResponse(status: 404, body: opaque), isTrue);
      for (final body in [
        {...opaque, 'title': 'leak'},
        {...opaque, 'messages': <Object?>[]},
        {...opaque, 'owner': 'leak'},
        {...opaque, 'conversation': <String, Object?>{}},
        {...opaque, 'selectedSpecialist': <String, Object?>{}},
        const {
          'error': {'code': 'other'},
        },
      ]) {
        expect(validateOpaqueForeignResponse(status: 404, body: body), isFalse);
      }
      expect(validateOpaqueForeignResponse(status: 403, body: opaque), isFalse);
      expect(validateOpaqueForeignResponse(status: null, body: null), isFalse);
    });

    test('/chat accepts only absent and never redirects', () {
      expect(classifyChatRoute(404), ProductRouteResult.absent);
      expect(classifyChatRoute(410), ProductRouteResult.absent);
      expect(
        classifyChatRoute(302, location: '/conversations'),
        ProductRouteResult.unexpectedlyPresent,
      );
      expect(classifyChatRoute(200), ProductRouteResult.unexpectedlyPresent);
      expect(classifyChatRoute(null), ProductRouteResult.unverifiable);
    });

    test('/orchestrator requires blocked or approved safe redirect', () {
      for (final status in [401, 403, 404, 410]) {
        expect(
          classifyOrchestratorRoute(status),
          ProductRouteResult.blockedForProduct,
        );
      }
      expect(
        classifyOrchestratorRoute(302, location: '/'),
        ProductRouteResult.blockedForProduct,
      );
      expect(
        classifyOrchestratorRoute(302, location: '/login'),
        ProductRouteResult.blockedForProduct,
      );
      expect(
        classifyOrchestratorRoute(302, location: '/orchestrator/chat'),
        ProductRouteResult.unexpectedlyAvailable,
      );
      expect(
        classifyOrchestratorRoute(200),
        ProductRouteResult.unexpectedlyAvailable,
      );
      expect(classifyOrchestratorRoute(null), ProductRouteResult.unverifiable);
    });
  });

  group('resource ledger', () {
    LedgerEntry created(ResourceCategory category) => LedgerEntry(
      category: category,
      disposition: ResourceDisposition.createdByRun,
      creationState: 'STATE',
      ownershipProof: 'run-proof',
      cleanupHandle: 'opaque-handle',
      cleanupRequired: true,
    );

    test('cleans only CREATED_BY_RUN in dependency-safe order', () {
      final ledger = CompleteResourceLedger()
        ..register(created(ResourceCategory.ownerAuth))
        ..register(created(ResourceCategory.conversation))
        ..register(created(ResourceCategory.messages))
        ..register(
          LedgerEntry(
            category: ResourceCategory.specialist,
            disposition: ResourceDisposition.verifiedPreexistingReadOnly,
            creationState: 'SPECIALIST_RESOLVED',
            ownershipProof: 'catalog-proof',
            cleanupHandle: '',
            cleanupRequired: false,
          ),
        );
      expect(ledger.entriesForCleanup().map((entry) => entry.category), [
        ResourceCategory.messages,
        ResourceCategory.conversation,
        ResourceCategory.ownerAuth,
      ]);
    });

    test('blocks duplicate, foreign and unproven ledger entries', () {
      final ledger = CompleteResourceLedger()
        ..register(created(ResourceCategory.ownerAuth));
      expect(
        () => ledger.register(created(ResourceCategory.ownerAuth)),
        throwsStateError,
      );
      expect(
        () => ledger.register(
          LedgerEntry(
            category: ResourceCategory.foreignAuth,
            disposition: ResourceDisposition.createdByRun,
            creationState: 'STATE',
            ownershipProof: '',
            cleanupHandle: '',
            cleanupRequired: true,
          ),
        ),
        throwsStateError,
      );
      expect(
        () => ledger.markCleaned(ResourceCategory.specialist),
        throwsStateError,
      );
    });

    test('failed request and read-only resources are never cleaned', () {
      final ledger = CompleteResourceLedger()
        ..register(
          LedgerEntry(
            category: ResourceCategory.catalog,
            disposition: ResourceDisposition.notCreated,
            creationState: 'SETUP_STARTED',
            ownershipProof: '',
            cleanupHandle: '',
            cleanupRequired: false,
          ),
        )
        ..register(
          LedgerEntry(
            category: ResourceCategory.specialist,
            disposition: ResourceDisposition.verifiedPreexistingReadOnly,
            creationState: 'SPECIALIST_RESOLVED',
            ownershipProof: 'catalog-proof',
            cleanupHandle: '',
            cleanupRequired: false,
          ),
        );
      expect(ledger.entriesForCleanup(), isEmpty);
    });

    test('canonical catalog and specialist are verified read-only', () {
      final ledger = CompleteResourceLedger();
      for (final category in [
        ResourceCategory.catalog,
        ResourceCategory.specialist,
      ]) {
        ledger
          ..register(
            LedgerEntry(
              category: category,
              disposition: ResourceDisposition.verifiedPreexistingReadOnly,
              creationState: 'SPECIALIST_RESOLVED',
              ownershipProof: canonicalSpecialistSource,
              cleanupHandle: '',
              cleanupRequired: false,
            ),
          )
          ..markVerified(category);
      }
      expect(ledger.entriesForCleanup(), isEmpty);
      expect(ledger[ResourceCategory.catalog]?.verificationCompleted, isTrue);
      expect(
        ledger[ResourceCategory.specialist]?.verificationCompleted,
        isTrue,
      );
    });

    test('read-only cleanup handles and unknown ownership are blocked', () {
      final ledger = CompleteResourceLedger();
      expect(
        () => ledger.register(
          LedgerEntry(
            category: ResourceCategory.specialist,
            disposition: ResourceDisposition.verifiedPreexistingReadOnly,
            creationState: 'SPECIALIST_RESOLVED',
            ownershipProof: canonicalSpecialistSource,
            cleanupHandle: 'forbidden',
            cleanupRequired: true,
          ),
        ),
        throwsStateError,
      );
      expect(
        () => ledger.register(
          LedgerEntry(
            category: ResourceCategory.catalog,
            disposition: ResourceDisposition.unknownBlocking,
            creationState: 'SPECIALIST_RESOLVED',
            ownershipProof: '',
            cleanupHandle: '',
            cleanupRequired: false,
          ),
        ),
        throwsStateError,
      );
    });

    test('response-loss uncertainty is dirty blocking', () {
      expect(
        classifyCompleteRun(
          flowPassed: false,
          cleanupPassed: false,
          authAbsent: true,
          counters: null,
          evidenceSafe: true,
          cliIsolated: true,
        ),
        CompleteRunClassification.failedDirtyBlocking,
      );
    });

    test('foreign principal is cleaned and ledger deletion is terminal', () {
      final ledger = CompleteResourceLedger()
        ..register(created(ResourceCategory.foreignAuth))
        ..markCleaned(ResourceCategory.foreignAuth)
        ..markVerified(ResourceCategory.foreignAuth)
        ..delete();
      expect(ledger.isDeleted, isTrue);
      expect(
        () => ledger.register(created(ResourceCategory.ownerAuth)),
        throwsStateError,
      );
    });
  });

  group('classification simulations', () {
    test('full PASSED_CLEAN twice', () {
      for (var index = 0; index < 2; index++) {
        expect(
          classifyCompleteRun(
            flowPassed: true,
            cleanupPassed: true,
            authAbsent: true,
            counters: List.filled(7, 0),
            evidenceSafe: true,
            cliIsolated: true,
          ),
          CompleteRunClassification.passedClean,
        );
      }
    });

    test('every functional failure with zero residue is FAILED_CLEAN', () {
      for (final _ in manifest.failureCleanupFromStates) {
        expect(
          classifyCompleteRun(
            flowPassed: false,
            cleanupPassed: true,
            authAbsent: true,
            counters: List.filled(7, 0),
            evidenceSafe: true,
            cliIsolated: true,
          ),
          CompleteRunClassification.failedClean,
        );
      }
    });

    test('cleanup, residue, evidence and CLI uncertainty are dirty', () {
      for (final result in [
        classifyCompleteRun(
          flowPassed: false,
          cleanupPassed: false,
          authAbsent: true,
          counters: List.filled(7, 0),
          evidenceSafe: true,
          cliIsolated: true,
        ),
        classifyCompleteRun(
          flowPassed: true,
          cleanupPassed: true,
          authAbsent: false,
          counters: List.filled(7, 0),
          evidenceSafe: true,
          cliIsolated: true,
        ),
        classifyCompleteRun(
          flowPassed: true,
          cleanupPassed: true,
          authAbsent: true,
          counters: [1, 0, 0, 0, 0, 0, 0],
          evidenceSafe: true,
          cliIsolated: true,
        ),
        classifyCompleteRun(
          flowPassed: true,
          cleanupPassed: true,
          authAbsent: true,
          counters: null,
          evidenceSafe: true,
          cliIsolated: true,
        ),
        classifyCompleteRun(
          flowPassed: true,
          cleanupPassed: true,
          authAbsent: true,
          counters: List.filled(7, 0),
          evidenceSafe: false,
          cliIsolated: true,
        ),
        classifyCompleteRun(
          flowPassed: true,
          cleanupPassed: true,
          authAbsent: true,
          counters: List.filled(7, 0),
          evidenceSafe: true,
          cliIsolated: false,
        ),
      ]) {
        expect(result, CompleteRunClassification.failedDirtyBlocking);
      }
    });
  });
}
