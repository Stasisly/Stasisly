import 'package:stasisly/core/authorization/domain/authorization_action.dart';
import 'package:stasisly/core/authorization/domain/authorization_context.dart';
import 'package:stasisly/core/authorization/domain/authorization_decision.dart';
import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_resource.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/domain/delegation_context.dart';
import 'package:stasisly/core/authorization/domain/elevation_context.dart';
import 'package:stasisly/core/authorization/domain/ownership_context.dart';
import 'package:stasisly/core/authorization/domain/purpose_context.dart';
import 'package:stasisly/core/authorization/domain/resource_sensitivity.dart';
import 'package:stasisly/core/authorization/ports/authorization_policy_decision_point.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';

class LocalFoundationPolicyDecisionPoint
    implements AuthorizationPolicyDecisionPoint {
  LocalFoundationPolicyDecisionPoint({DateTime Function()? clock})
    : _clock = clock ?? DateTime.now;

  static const policyReference = 'foundation-009/local-deny-default-v1';

  final DateTime Function() _clock;

  @override
  Future<AuthorizationDecision> evaluate(AuthorizationContext context) async {
    final identity = context.identity;
    if (identity == null) {
      return _deny(context, AuthorizationReasonCode.missingContext);
    }
    if (identity.authenticationState == AuthenticationState.unauthenticated) {
      return _deny(context, AuthorizationReasonCode.unauthenticated);
    }
    if (!identity.isAuthenticated ||
        identity.identityType == IdentityType.unknown) {
      return _deny(context, AuthorizationReasonCode.invalidIdentity);
    }

    final action = context.action;
    if (action == null) {
      return _deny(context, AuthorizationReasonCode.missingContext);
    }
    if (action == AuthorizationAction.unknown) {
      return _deny(context, AuthorizationReasonCode.unknownAction);
    }

    final resource = context.resource;
    if (resource == null) {
      return _deny(context, AuthorizationReasonCode.missingContext);
    }
    if (resource.type == AuthorizationResourceType.unknown ||
        resource.sensitivity == ResourceSensitivity.unknown) {
      return _deny(context, AuthorizationReasonCode.unknownResource);
    }

    final surface = context.surface;
    if (surface == null) {
      return _deny(context, AuthorizationReasonCode.missingContext);
    }
    if (surface == AuthorizationSurface.unknown ||
        resource.surface != surface) {
      return _deny(context, AuthorizationReasonCode.surfaceMismatch);
    }

    final environment = context.environment;
    if (environment == null) {
      return _deny(context, AuthorizationReasonCode.missingContext);
    }
    if (environment == AuthorizationEnvironment.unknown ||
        environment != AuthorizationEnvironment.local &&
            environment != AuthorizationEnvironment.development) {
      return _deny(context, AuthorizationReasonCode.environmentMismatch);
    }

    final now = _clock().toUtc();
    if (!context.delegation.isValidFor(
      subjectId: identity.subjectId,
      action: action,
      resourceType: resource.type,
      requestSurface: surface,
      requestEnvironment: environment,
      now: now,
    )) {
      return _deny(context, AuthorizationReasonCode.invalidDelegation);
    }

    if (context.elevation.status == ElevationStatus.expired) {
      return _deny(context, AuthorizationReasonCode.elevationExpired);
    }
    if (!context.elevation.isValidFor(
      action: action,
      resourceType: resource.type,
      requestSurface: surface,
      requestEnvironment: environment,
      now: now,
    )) {
      return _deny(context, AuthorizationReasonCode.explicitDeny);
    }

    if (resource.owner != null &&
        context.ownership.status != OwnershipStatus.owned) {
      return _deny(context, AuthorizationReasonCode.notOwner);
    }
    if (!context.entitlement.satisfiesRequirement) {
      return _deny(context, AuthorizationReasonCode.missingEntitlement);
    }
    if (context.purpose.purpose == AuthorizationPurpose.unknown) {
      return _deny(context, AuthorizationReasonCode.missingContext);
    }

    if (resource.sensitivity == ResourceSensitivity.rootCritical &&
        !context.elevation.isElevated) {
      return _require(
        context,
        AuthorizationDecisionType.requireElevation,
        AuthorizationReasonCode.elevationRequired,
        AuthorizationObligation.obtainElevation,
      );
    }
    if (action == AuthorizationAction.approve) {
      return _require(
        context,
        AuthorizationDecisionType.requireApproval,
        AuthorizationReasonCode.approvalRequired,
        AuthorizationObligation.obtainApproval,
      );
    }
    if (resource.type == AuthorizationResourceType.memory &&
        resource.sensitivity == ResourceSensitivity.highlySensitive) {
      return _require(
        context,
        AuthorizationDecisionType.requireUserConsent,
        AuthorizationReasonCode.userConsentRequired,
        AuthorizationObligation.obtainUserConsent,
      );
    }

    final isOwnProfileRead =
        identity.identityType == IdentityType.humanUser &&
        action == AuthorizationAction.read &&
        resource.type == AuthorizationResourceType.profile &&
        surface == AuthorizationSurface.product &&
        context.ownership.status == OwnershipStatus.owned;

    if (isOwnProfileRead) {
      return AuthorizationDecision(
        type: AuthorizationDecisionType.allow,
        reasonCode: AuthorizationReasonCode.authenticated,
        policyReference: policyReference,
        auditRequired: _auditRequired(context),
        obligations: _auditRequired(context)
            ? const {AuthorizationObligation.recordAudit}
            : const {},
      );
    }

    return _deny(context, AuthorizationReasonCode.explicitDeny);
  }

  AuthorizationDecision _deny(
    AuthorizationContext context,
    AuthorizationReasonCode reason,
  ) {
    final audit = _auditRequired(context);
    return AuthorizationDecision(
      type: AuthorizationDecisionType.deny,
      reasonCode: reason,
      policyReference: policyReference,
      auditRequired: audit,
      obligations: audit
          ? const {AuthorizationObligation.recordAudit}
          : const {},
    );
  }

  AuthorizationDecision _require(
    AuthorizationContext context,
    AuthorizationDecisionType type,
    AuthorizationReasonCode reason,
    AuthorizationObligation obligation,
  ) {
    return AuthorizationDecision(
      type: type,
      reasonCode: reason,
      policyReference: policyReference,
      auditRequired: true,
      obligations: {AuthorizationObligation.recordAudit, obligation},
    );
  }

  bool _auditRequired(AuthorizationContext context) {
    final sensitivity = context.resource?.sensitivity;
    return sensitivity == ResourceSensitivity.sensitive ||
        sensitivity == ResourceSensitivity.highlySensitive ||
        sensitivity == ResourceSensitivity.rootCritical ||
        context.delegation.status == DelegationStatus.active ||
        context.elevation.isElevated;
  }
}
