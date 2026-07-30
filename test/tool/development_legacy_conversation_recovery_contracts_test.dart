import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import '../../tool/development_legacy_conversation_recovery_contracts.dart';
import '../../tool/founder_authorization_artifact.dart';

const _manifestPath =
    'docs/stasisly_foundation/development/'
    'development_v4_legacy_conversation_recovery_manifest.json';
const _conversation = '11111111-1111-4111-8111-111111111111';
const _owner = '22222222-2222-4222-8222-222222222222';
const _foreignOwner = '33333333-3333-4333-8333-333333333333';
const _runBinding = 'integrity-bound-run';

void main() {
  group('legacy manifest and evidence inventory', () {
    test('manifest is valid and deliberately has no executable strategy', () {
      final manifest = LegacyConversationRecoveryManifest.read(
        File(_manifestPath),
      );

      expect(manifest.validate(), isEmpty);
      expect(manifest.maximumRequestCount, 0);
      expect(manifest.maximumResultCardinality, 0);
      expect(manifest.deleteEnabled, isFalse);
      expect(manifest.diagnosticOnly, isTrue);
      expect(
        manifest.strategies.any((strategy) => strategy.isAdmissible),
        false,
      );
      expect(
        manifest.candidates.any((candidate) => candidate.canAuthorizeLookup),
        false,
      );
    });

    test('exact context bindings do not become resource identity', () {
      final manifest = LegacyConversationRecoveryManifest.read(
        File(_manifestPath),
      );
      final contextCandidates = manifest.candidates.where(
        (candidate) => {
          'FAILED_AUTHORIZATION_BINDING',
          'MANIFEST_RUNNER_BINDING',
        }.contains(candidate.name),
      );

      expect(contextCandidates, hasLength(2));
      expect(
        contextCandidates.every(
          (candidate) =>
              candidate.classification ==
                  HistoricalIdentityCandidateClassification.exactAndAvailable &&
              !candidate.backendSupported &&
              !candidate.ownershipVerifiable,
        ),
        isTrue,
      );
    });

    test('historical handles and alias are exact but unavailable', () {
      final manifest = LegacyConversationRecoveryManifest.read(
        File(_manifestPath),
      );
      for (final name in {
        'CANONICAL_CONVERSATION_ID',
        'CREATE_RESPONSE_SESSION_ID',
        'OPERATION_ATTEMPT_ID',
        'IDEMPOTENCY_KEY',
        'SYNTHETIC_OWNER_ID',
        'RUN_ALIAS',
        'HISTORICAL_RESOURCE_LEDGER',
      }) {
        final candidate = manifest.candidates.singleWhere(
          (candidate) => candidate.name == name,
        );
        expect(
          candidate.classification,
          HistoricalIdentityCandidateClassification.exactButNotAvailable,
        );
        expect(candidate.available, isFalse);
      }
    });

    test('owner-only, temporal and paginated strategies remain unsafe', () {
      final manifest = LegacyConversationRecoveryManifest.read(
        File(_manifestPath),
      );
      for (final name in {
        'OWNER_ONLY',
        'DATE_WINDOW_OR_ORDERING',
        'UNBOUNDED_OR_PAGINATED_LIST',
      }) {
        final strategy = manifest.strategies.singleWhere(
          (strategy) => strategy.name == name,
        );
        expect(strategy.status, LegacyRecoveryStrategyStatus.unsafe);
        expect(strategy.isAdmissible, isFalse);
      }
    });
  });

  group('exact existence and absence proof', () {
    test('one exact owned row creates a redacted ownership proof', () {
      final assessment = _assessment(rows: [_ownedRow()]);

      expect(assessment.cardinality, LegacyLookupCardinality.exactlyOne);
      expect(
        assessment.result,
        LegacyConversationRecoveryResult.exactlyIdentified,
      );
      expect(assessment.proof, isNotNull);
      expect(assessment.proof.toString(), contains('<redacted>'));
      expect(assessment.proof.toString(), isNot(contains(_conversation)));
    });

    test('exact complete zero proves absence', () {
      final assessment = _assessment();

      expect(assessment.cardinality, LegacyLookupCardinality.exactlyZero);
      expect(assessment.result, LegacyConversationRecoveryResult.exactlyAbsent);
    });

    test('contractual exact 404 proves absence', () {
      final assessment = _assessment(
        status: 404,
        status404MeansExactAbsence: true,
      );

      expect(assessment.cardinality, LegacyLookupCardinality.exactlyZero);
    });

    test('ambiguous 404 is a query failure, never absence', () {
      final assessment = _assessment(status: 404);

      expect(assessment.cardinality, LegacyLookupCardinality.queryFailed);
      expect(assessment.result, LegacyConversationRecoveryResult.lookupFailed);
    });

    test('multiple rows are ambiguous', () {
      final assessment = _assessment(rows: [_ownedRow(), _ownedRow()]);

      expect(assessment.cardinality, LegacyLookupCardinality.ambiguous);
      expect(assessment.result, LegacyConversationRecoveryResult.ambiguous);
    });

    test('foreign owner blocks ownership proof', () {
      final assessment = _assessment(
        rows: [_ownedRow(ownerHandle: _foreignOwner)],
      );

      expect(assessment.cardinality, LegacyLookupCardinality.foreign);
      expect(assessment.result, LegacyConversationRecoveryResult.foreign);
    });

    test('wrong run binding cannot identify the resource', () {
      final assessment = _assessment(
        rows: [_ownedRow(runBinding: 'different-run')],
      );

      expect(
        assessment.cardinality,
        LegacyLookupCardinality.contractInsufficient,
      );
    });

    test('canonical resource is never cleanup eligible', () {
      final assessment = _assessment(
        rows: [_ownedRow(resourceClassification: 'CANONICAL')],
      );

      expect(
        assessment.result,
        LegacyConversationRecoveryResult.exactRecoveryUnavailable,
      );
    });

    test('unknown ownership cannot identify the resource', () {
      final assessment = _assessment(rows: [_ownedRow(ownership: 'UNKNOWN')]);

      expect(
        assessment.cardinality,
        LegacyLookupCardinality.contractInsufficient,
      );
    });

    test(
      'partial, paginated, null and non-exact responses are insufficient',
      () {
        final inputs = [
          _assessment(rows: [_ownedRow()], responseComplete: false),
          _assessment(rows: [_ownedRow()], paginationPresent: true),
          _assessment(rows: null),
          _assessment(rows: [_ownedRow()], exactLookupContract: false),
        ];

        expect(
          inputs.every(
            (assessment) =>
                assessment.cardinality ==
                LegacyLookupCardinality.contractInsufficient,
          ),
          isTrue,
        );
      },
    );

    test('permission, timeout and backend errors are query failures', () {
      for (final status in [401, 403, 408, 500, 503]) {
        final assessment = _assessment(status: status);
        expect(assessment.cardinality, LegacyLookupCardinality.queryFailed);
        expect(
          assessment.result,
          LegacyConversationRecoveryResult.lookupFailed,
        );
      }
    });

    test('empty or invalid exact handles cannot create ownership proof', () {
      for (final handle in ['', 'not-a-uuid']) {
        expect(
          () => LegacyConversationOwnershipProof.validated(
            lookupStrategy: 'EXACT_CANONICAL_ID',
            conversationHandle: handle,
            ownerHandle: _owner,
            runBinding: _runBinding,
            subjectRun: expectedLegacySubjectRun(),
            ownership: 'CREATED_BY_RUN',
            resourceClassification: 'NON_CANONICAL',
            cleanupEligible: true,
          ),
          throwsFormatException,
        );
      }
    });
  });

  group('request budget and dependent resources', () {
    test('bounded exact actions consume the budget', () {
      final budget = LegacyRecoveryRequestBudget(maximumRequests: 3);

      for (final action in [
        'TARGET_VERIFICATION',
        'EXACT_CONVERSATION_LOOKUP',
        'EXACT_OWNERSHIP_VERIFICATION',
      ]) {
        budget.authorize(action: action);
      }

      expect(budget.remaining, 0);
      expect(
        () => budget.authorize(action: 'EXACT_CONVERSATION_LOOKUP'),
        throwsStateError,
      );
    });

    test('zero budget blocks every future remote action', () {
      final budget = LegacyRecoveryRequestBudget(maximumRequests: 0);

      expect(
        () => budget.authorize(action: 'TARGET_VERIFICATION'),
        throwsStateError,
      );
    });

    test('pagination, fallback, broad lookup and delete always block', () {
      final attempts = [
        () => LegacyRecoveryRequestBudget(
          maximumRequests: 1,
        ).authorize(action: 'EXACT_CONVERSATION_LOOKUP', pagination: true),
        () => LegacyRecoveryRequestBudget(
          maximumRequests: 1,
        ).authorize(action: 'EXACT_CONVERSATION_LOOKUP', fallback: true),
        () => LegacyRecoveryRequestBudget(
          maximumRequests: 1,
        ).authorize(action: 'EXACT_CONVERSATION_LOOKUP', broadLookup: true),
        () => LegacyRecoveryRequestBudget(
          maximumRequests: 1,
        ).authorize(action: 'EXACT_CONVERSATION_LOOKUP', delete: true),
      ];

      for (final attempt in attempts) {
        expect(attempt, throwsStateError);
      }
    });

    test('messages require exact Conversation proof or cascade absence', () {
      expect(
        classifyLegacyMessagesPolicy(
          conversationResult:
              LegacyConversationRecoveryResult.exactlyIdentified,
          cascadeGuaranteed: false,
          exactLookupCompleted: true,
        ),
        'EXACT_MESSAGES_LOOKUP_ALLOWED',
      );
      expect(
        classifyLegacyMessagesPolicy(
          conversationResult: LegacyConversationRecoveryResult.exactlyAbsent,
          cascadeGuaranteed: true,
          exactLookupCompleted: false,
        ),
        'MESSAGES_ZERO_BY_SCHEMA_DEPENDENCY',
      );
      expect(
        classifyLegacyMessagesPolicy(
          conversationResult: LegacyConversationRecoveryResult.exactlyAbsent,
          cascadeGuaranteed: false,
          exactLookupCompleted: false,
        ),
        'MESSAGES_UNKNOWN_BLOCKING',
      );
    });

    test('sessions never use owner-wide discovery', () {
      expect(
        classifyLegacySessionsPolicy(
          conversationResult:
              LegacyConversationRecoveryResult.exactlyIdentified,
          exactSessionKeyAvailable: true,
        ),
        'EXACT_SESSION_LOOKUP_AVAILABLE',
      );
      expect(
        classifyLegacySessionsPolicy(
          conversationResult:
              LegacyConversationRecoveryResult.exactRecoveryUnavailable,
          exactSessionKeyAvailable: false,
        ),
        'SESSION_REMAINS_UNKNOWN',
      );
    });
  });

  group('ArtifactV2 historical bindings', () {
    test('valid artifact binds all seven subject-run fields', () {
      final artifact = _artifact();
      final findings = artifact.validate(
        now: DateTime.utc(2026, 7, 31, 10, 30),
        expectedOperation: 'FOUNDATION-019A_FAILED_RUN_FORENSIC_REVIEW',
        expectedEnvironment: 'development',
        expectedCommitSha: 'a' * 40,
        expectedManifest: legacyConversationRecoveryManifestVersion,
        expectedRunner: legacyConversationRecoveryRunnerVersion,
        expectedSubjectRun: expectedLegacySubjectRun(),
      );

      expect(findings, isEmpty);
      expect(artifact.hasValidHash, isTrue);
    });

    test('every wrong historical binding is rejected', () {
      final expected = expectedLegacySubjectRun();
      final variants = [
        FounderAuthorizationSubjectRun(
          authorizationReference: 'different-reference',
          commitSha: expected.commitSha,
          manifest: expected.manifest,
          runner: expected.runner,
          result: expected.result,
          lastReachedState: expected.lastReachedState,
          failureCategory: expected.failureCategory,
        ),
        FounderAuthorizationSubjectRun(
          authorizationReference: expected.authorizationReference,
          commitSha: 'b' * 40,
          manifest: expected.manifest,
          runner: expected.runner,
          result: expected.result,
          lastReachedState: expected.lastReachedState,
          failureCategory: expected.failureCategory,
        ),
        FounderAuthorizationSubjectRun(
          authorizationReference: expected.authorizationReference,
          commitSha: expected.commitSha,
          manifest: 'different-manifest',
          runner: expected.runner,
          result: expected.result,
          lastReachedState: expected.lastReachedState,
          failureCategory: expected.failureCategory,
        ),
        FounderAuthorizationSubjectRun(
          authorizationReference: expected.authorizationReference,
          commitSha: expected.commitSha,
          manifest: expected.manifest,
          runner: 'different-runner',
          result: expected.result,
          lastReachedState: expected.lastReachedState,
          failureCategory: expected.failureCategory,
        ),
        FounderAuthorizationSubjectRun(
          authorizationReference: expected.authorizationReference,
          commitSha: expected.commitSha,
          manifest: expected.manifest,
          runner: expected.runner,
          result: 'DIFFERENT RESULT',
          lastReachedState: expected.lastReachedState,
          failureCategory: expected.failureCategory,
        ),
        FounderAuthorizationSubjectRun(
          authorizationReference: expected.authorizationReference,
          commitSha: expected.commitSha,
          manifest: expected.manifest,
          runner: expected.runner,
          result: expected.result,
          lastReachedState: 'DIFFERENT_STATE',
          failureCategory: expected.failureCategory,
        ),
        FounderAuthorizationSubjectRun(
          authorizationReference: expected.authorizationReference,
          commitSha: expected.commitSha,
          manifest: expected.manifest,
          runner: expected.runner,
          result: expected.result,
          lastReachedState: expected.lastReachedState,
          failureCategory: 'DIFFERENT_CATEGORY',
        ),
      ];

      for (final variant in variants) {
        expect(variant.validate(expected: expected), isNotEmpty);
      }
    });

    test('expired, consumed and corrupt artifacts fail closed', () {
      final valid = _artifact();
      final expired = valid
          .copyWith(
            status: FounderAuthorizationStatus.expired,
            expiredAt: DateTime.utc(2026, 7, 31, 10),
          )
          .withRecalculatedHash();
      final consumed = valid
          .copyWith(
            status: FounderAuthorizationStatus.consumed,
            remoteExecutionCount: 1,
            consumedAt: DateTime.utc(2026, 7, 31, 10),
          )
          .withRecalculatedHash();
      final corrupt = valid.copyWith(payloadSha256: '0' * 64);

      expect(
        expired.validate(now: DateTime.utc(2026, 7, 31, 10, 30)),
        isNotEmpty,
      );
      expect(
        consumed.validate(now: DateTime.utc(2026, 7, 31, 10, 30)),
        isNotEmpty,
      );
      expect(corrupt.hasValidHash, isFalse);
    });
  });
}

LegacyLookupAssessment _assessment({
  int status = 200,
  List<LegacyLookupRow>? rows = const [],
  bool responseComplete = true,
  bool paginationPresent = false,
  bool exactLookupContract = true,
  bool status404MeansExactAbsence = false,
}) => assessLegacyLookup(
  status: status,
  rows: rows,
  responseComplete: responseComplete,
  paginationPresent: paginationPresent,
  exactLookupContract: exactLookupContract,
  status404MeansExactAbsence: status404MeansExactAbsence,
  expectedOwnerHandle: _owner,
  expectedRunBinding: _runBinding,
);

LegacyLookupRow _ownedRow({
  String ownerHandle = _owner,
  String runBinding = _runBinding,
  String resourceClassification = 'NON_CANONICAL',
  String ownership = 'CREATED_BY_RUN',
}) => LegacyLookupRow(
  conversationHandle: _conversation,
  ownerHandle: ownerHandle,
  runBinding: runBinding,
  resourceType: 'Conversation',
  resourceClassification: resourceClassification,
  ownership: ownership,
);

FounderAuthorizationArtifactV2 _artifact() =>
    FounderAuthorizationArtifactV2.granted(
      proposal: FounderAuthorizationProposalV2(
        authorizationId: 'future-r2j-diagnostic',
        decision: 'APPROVED',
        decisionSource: 'FOUNDER_CONVERSATION',
        authorizedOperation: 'FOUNDATION-019A_FAILED_RUN_FORENSIC_REVIEW',
        authorizedEnvironment: 'development',
        authorizedManifest: legacyConversationRecoveryManifestVersion,
        authorizedRunner: legacyConversationRecoveryRunnerVersion,
        scope: 'DIAGNOSTIC_ONLY',
        subjectRun: expectedLegacySubjectRun(),
      ),
      commitSha: 'a' * 40,
      now: DateTime.utc(2026, 7, 31, 10),
    );
