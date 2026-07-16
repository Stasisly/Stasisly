import 'package:stasisly/core/authorization/authorization.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

class OwnProfileReadAuthorizationGate {
  const OwnProfileReadAuthorizationGate(this._enforcer);

  final AuthorizationEnforcer _enforcer;

  Future<AuthorizationDecision> authorize({
    required StasislyIdentity identity,
    required String trustedProfileSubjectId,
    required AuthorizationEnvironment environment,
    required String correlationId,
  }) {
    final resource = AuthorizationResource(
      type: AuthorizationResourceType.profile,
      resourceId: trustedProfileSubjectId,
      owner: TrustedOwnerReference.fromTrustedBoundary(
        subjectId: trustedProfileSubjectId,
        source: OwnerReferenceSource.trustedBackend,
      ),
      sensitivity: ResourceSensitivity.confidential,
      surface: AuthorizationSurface.product,
    );
    return _enforcer.enforce(
      AuthorizationContext(
        identity: identity,
        action: AuthorizationAction.read,
        resource: resource,
        surface: AuthorizationSurface.product,
        environment: environment,
        ownership: OwnershipContext.fromTrustedResource(
          identity: identity,
          resource: resource,
        ),
        entitlement: const EntitlementContext.notRequired(),
        purpose: PurposeContext(AuthorizationPurpose.userRequested),
        correlationId: correlationId,
      ),
    );
  }
}
