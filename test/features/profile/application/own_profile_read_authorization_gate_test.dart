import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/authorization/authorization.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/features/profile/application/own_profile_read_authorization_gate.dart';

void main() {
  final gate = OwnProfileReadAuthorizationGate(
    DefaultAuthorizationEnforcer(
      decisionPoint: LocalFoundationPolicyDecisionPoint(),
      auditSink: const LocalNoOpAuthorizationAuditSink(),
    ),
  );

  test(
    'own authenticated profile read permits in local development only',
    () async {
      final local = await gate.authorize(
        identity: _identity,
        trustedProfileSubjectId: 'subject-1',
        environment: AuthorizationEnvironment.local,
        correlationId: 'profile-local',
      );
      final development = await gate.authorize(
        identity: _identity,
        trustedProfileSubjectId: 'subject-1',
        environment: AuthorizationEnvironment.development,
        correlationId: 'profile-development',
      );

      expect(local.type, AuthorizationDecisionType.allow);
      expect(development.type, AuthorizationDecisionType.allow);
    },
  );

  test('another owner, missing authentication and production deny', () async {
    final notOwner = await gate.authorize(
      identity: _identity,
      trustedProfileSubjectId: 'subject-2',
      environment: AuthorizationEnvironment.local,
      correlationId: 'profile-other',
    );
    final unauthenticated = await gate.authorize(
      identity: const StasislyIdentity(
        subjectId: 'subject-1',
        identityType: IdentityType.humanUser,
        authenticationState: AuthenticationState.unauthenticated,
      ),
      trustedProfileSubjectId: 'subject-1',
      environment: AuthorizationEnvironment.local,
      correlationId: 'profile-unauthenticated',
    );
    final production = await gate.authorize(
      identity: _identity,
      trustedProfileSubjectId: 'subject-1',
      environment: AuthorizationEnvironment.production,
      correlationId: 'profile-production',
    );

    expect(notOwner.reasonCode, AuthorizationReasonCode.notOwner);
    expect(unauthenticated.reasonCode, AuthorizationReasonCode.unauthenticated);
    expect(production.reasonCode, AuthorizationReasonCode.environmentMismatch);
  });
}

const _identity = StasislyIdentity(
  subjectId: 'subject-1',
  identityType: IdentityType.humanUser,
  authenticationState: AuthenticationState.authenticated,
);
