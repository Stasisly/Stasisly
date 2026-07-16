import 'package:equatable/equatable.dart';

enum AuthorizationDecisionType {
  allow,
  deny,
  requireElevation,
  requireApproval,
  requireUserConsent,
  notApplicable,
}

enum AuthorizationReasonCode {
  authenticated,
  unauthenticated,
  invalidIdentity,
  missingContext,
  unknownAction,
  unknownResource,
  surfaceMismatch,
  environmentMismatch,
  notOwner,
  missingEntitlement,
  invalidDelegation,
  elevationRequired,
  elevationExpired,
  approvalRequired,
  userConsentRequired,
  policyUnavailable,
  policyError,
  explicitDeny,
  notApplicable,
}

enum AuthorizationObligation {
  recordAudit,
  obtainElevation,
  obtainApproval,
  obtainUserConsent,
}

class AuthorizationDecision extends Equatable {
  const AuthorizationDecision({
    required this.type,
    required this.reasonCode,
    required this.policyReference,
    required this.auditRequired,
    this.obligations = const {},
  });

  final AuthorizationDecisionType type;
  final AuthorizationReasonCode reasonCode;
  final String policyReference;
  final bool auditRequired;
  final Set<AuthorizationObligation> obligations;

  bool get isAllowed => type == AuthorizationDecisionType.allow;

  @override
  List<Object?> get props => [
    type,
    reasonCode,
    policyReference,
    auditRequired,
    obligations,
  ];
}
