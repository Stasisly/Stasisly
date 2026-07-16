import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/authorization.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

void main() {
  final now = DateTime.utc(2026, 7, 16, 12);
  final policy = LocalFoundationPolicyDecisionPoint(clock: () => now);

  Future<AuthorizationDecision> evaluate({
    StasislyIdentity? identity = _authenticatedIdentity,
    AuthorizationAction? action = AuthorizationAction.read,
    AuthorizationResource? resource,
    AuthorizationSurface? surface = AuthorizationSurface.product,
    AuthorizationEnvironment? environment = AuthorizationEnvironment.local,
    OwnershipContext? ownership,
    EntitlementContext entitlement = const EntitlementContext.notRequired(),
    PurposeContext? purpose,
    DelegationContext delegation = const DelegationContext.none(),
    ElevationContext elevation = const ElevationContext.none(),
  }) {
    final resolvedResource = resource ?? _profileResource(owner: 'subject-1');
    return policy.evaluate(
      AuthorizationContext(
        identity: identity,
        action: action,
        resource: resolvedResource,
        surface: surface,
        environment: environment,
        ownership:
            ownership ??
            (identity == null
                ? const OwnershipContext.unknown()
                : OwnershipContext.fromTrustedResource(
                    identity: identity,
                    resource: resolvedResource,
                  )),
        entitlement: entitlement,
        purpose: purpose ?? PurposeContext(AuthorizationPurpose.userRequested),
        delegation: delegation,
        elevation: elevation,
        correlationId: 'test-correlation',
      ),
    );
  }

  test('authenticated own profile read allows in local context', () async {
    final decision = await evaluate();

    expect(decision.type, AuthorizationDecisionType.allow);
    expect(decision.reasonCode, AuthorizationReasonCode.authenticated);
  });

  test('unauthenticated and unknown identity deny', () async {
    final unauthenticated = await evaluate(
      identity: const StasislyIdentity(
        subjectId: 'subject-1',
        identityType: IdentityType.humanUser,
        authenticationState: AuthenticationState.unauthenticated,
      ),
    );
    final unknown = await evaluate(
      identity: const StasislyIdentity(
        subjectId: 'subject-1',
        identityType: IdentityType.unknown,
        authenticationState: AuthenticationState.unknown,
      ),
    );

    expect(unauthenticated.type, AuthorizationDecisionType.deny);
    expect(unauthenticated.reasonCode, AuthorizationReasonCode.unauthenticated);
    expect(unknown.type, AuthorizationDecisionType.deny);
    expect(unknown.reasonCode, AuthorizationReasonCode.invalidIdentity);
  });

  test('missing identity, surface and environment deny', () async {
    expect(
      (await evaluate(identity: null)).reasonCode,
      AuthorizationReasonCode.missingContext,
    );
    expect(
      (await evaluate(surface: null)).reasonCode,
      AuthorizationReasonCode.missingContext,
    );
    expect(
      (await evaluate(environment: null)).reasonCode,
      AuthorizationReasonCode.missingContext,
    );
  });

  test('unknown and mismatched surface deny', () async {
    expect(
      (await evaluate(surface: AuthorizationSurface.unknown)).reasonCode,
      AuthorizationReasonCode.surfaceMismatch,
    );
    expect(
      (await evaluate(surface: AuthorizationSurface.development)).reasonCode,
      AuthorizationReasonCode.surfaceMismatch,
    );
  });

  test('unknown and unapproved environments deny without fallback', () async {
    expect(
      (await evaluate(
        environment: AuthorizationEnvironment.unknown,
      )).reasonCode,
      AuthorizationReasonCode.environmentMismatch,
    );
    expect(
      (await evaluate(
        environment: AuthorizationEnvironment.production,
      )).reasonCode,
      AuthorizationReasonCode.environmentMismatch,
    );
    expect(
      (await evaluate(environment: AuthorizationEnvironment.demo)).reasonCode,
      AuthorizationReasonCode.environmentMismatch,
    );
  });

  test('unknown action and resource deny', () async {
    expect(
      (await evaluate(action: AuthorizationAction.unknown)).reasonCode,
      AuthorizationReasonCode.unknownAction,
    );
    expect(
      (await evaluate(
        resource: AuthorizationResource(
          type: AuthorizationResourceType.unknown,
          sensitivity: ResourceSensitivity.internal,
          surface: AuthorizationSurface.product,
        ),
      )).reasonCode,
      AuthorizationReasonCode.unknownResource,
    );
  });

  test('backend-derived owner allows and another owner denies', () async {
    final owned = await evaluate();
    final otherResource = _profileResource(owner: 'subject-2');
    final notOwned = await evaluate(
      resource: otherResource,
      ownership: OwnershipContext.fromTrustedResource(
        identity: _authenticatedIdentity,
        resource: otherResource,
      ),
    );

    expect(owned.type, AuthorizationDecisionType.allow);
    expect(notOwned.type, AuthorizationDecisionType.deny);
    expect(notOwned.reasonCode, AuthorizationReasonCode.notOwner);
  });

  test('plan alone never grants a required entitlement', () async {
    final missing = await evaluate(
      entitlement: const EntitlementContext.unknown(plan: CommercialPlan.pro),
    );
    final granted = await evaluate(
      entitlement: const EntitlementContext.granted(plan: CommercialPlan.free),
    );

    expect(missing.reasonCode, AuthorizationReasonCode.missingEntitlement);
    expect(granted.type, AuthorizationDecisionType.allow);
  });

  test('expired and revoked delegation deny', () async {
    expect(
      (await evaluate(
        delegation: const DelegationContext.expired(),
      )).reasonCode,
      AuthorizationReasonCode.invalidDelegation,
    );
    expect(
      (await evaluate(
        delegation: const DelegationContext.revoked(),
      )).reasonCode,
      AuthorizationReasonCode.invalidDelegation,
    );
  });

  test(
    'valid bounded delegation preserves decision and requires audit',
    () async {
      final decision = await evaluate(
        delegation: DelegationContext.active(
          delegatorSubjectId: 'delegator',
          delegateSubjectId: 'subject-1',
          resourceScope: const {AuthorizationResourceType.profile},
          actionScope: const {AuthorizationAction.read},
          surface: AuthorizationSurface.product,
          environment: AuthorizationEnvironment.local,
          issuedAt: now.subtract(const Duration(minutes: 1)),
          expiresAt: now.add(const Duration(minutes: 1)),
        ),
      );

      expect(decision.type, AuthorizationDecisionType.allow);
      expect(decision.auditRequired, isTrue);
    },
  );

  test(
    'root-critical operation requires elevation and expired denies',
    () async {
      final resource = AuthorizationResource(
        type: AuthorizationResourceType.configuration,
        sensitivity: ResourceSensitivity.rootCritical,
        surface: AuthorizationSurface.sharedInfrastructure,
      );
      final required = await evaluate(
        action: AuthorizationAction.configure,
        resource: resource,
        surface: AuthorizationSurface.sharedInfrastructure,
        ownership: const OwnershipContext.notApplicable(),
        purpose: PurposeContext(AuthorizationPurpose.security),
      );
      final expired = await evaluate(
        action: AuthorizationAction.configure,
        resource: resource,
        surface: AuthorizationSurface.sharedInfrastructure,
        ownership: const OwnershipContext.notApplicable(),
        purpose: PurposeContext(AuthorizationPurpose.security),
        elevation: const ElevationContext.expired(),
      );

      expect(required.type, AuthorizationDecisionType.requireElevation);
      expect(required.auditRequired, isTrue);
      expect(expired.type, AuthorizationDecisionType.deny);
      expect(expired.reasonCode, AuthorizationReasonCode.elevationExpired);
    },
  );

  test('approval and user consent are typed non-allow decisions', () async {
    final approval = await evaluate(action: AuthorizationAction.approve);
    final consent = await evaluate(
      resource: AuthorizationResource(
        type: AuthorizationResourceType.memory,
        sensitivity: ResourceSensitivity.highlySensitive,
        surface: AuthorizationSurface.product,
      ),
      ownership: const OwnershipContext.notApplicable(),
    );

    expect(approval.type, AuthorizationDecisionType.requireApproval);
    expect(consent.type, AuthorizationDecisionType.requireUserConsent);
    expect(approval.isAllowed, isFalse);
    expect(consent.isAllowed, isFalse);
  });

  test('unlisted operation explicitly denies', () async {
    final decision = await evaluate(action: AuthorizationAction.update);

    expect(decision.type, AuthorizationDecisionType.deny);
    expect(decision.reasonCode, AuthorizationReasonCode.explicitDeny);
  });
}

const _authenticatedIdentity = StasislyIdentity(
  subjectId: 'subject-1',
  identityType: IdentityType.humanUser,
  authenticationState: AuthenticationState.authenticated,
);

AuthorizationResource _profileResource({required String owner}) {
  return AuthorizationResource(
    type: AuthorizationResourceType.profile,
    resourceId: owner,
    owner: TrustedOwnerReference.fromTrustedBoundary(
      subjectId: owner,
      source: OwnerReferenceSource.trustedBackend,
    ),
    sensitivity: ResourceSensitivity.confidential,
    surface: AuthorizationSurface.product,
  );
}
