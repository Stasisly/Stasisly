import 'package:equatable/equatable.dart';

enum BoundaryDecisionType {
  allow,
  deny,
  redirectToAuthentication,
  blockedByEnvironment,
  blockedBySurface,
  legacyBlocked,
  notAvailable,
}

enum BoundaryReasonCode {
  allowed,
  authenticationRequired,
  missingMetadata,
  unknownEntryPoint,
  unknownSurface,
  surfaceMismatch,
  unknownEnvironment,
  environmentMismatch,
  legacyCapability,
  capabilityNotAvailable,
  policyDenied,
}

enum BoundarySafeUserMessageKey {
  none,
  authenticationRequired,
  accessDenied,
  environmentBlocked,
  legacyUnavailable,
  notAvailable,
}

class BoundaryDecision extends Equatable {
  const BoundaryDecision({
    required this.type,
    required this.reasonCode,
    required this.auditRequired,
    required this.safeUserMessageKey,
  });

  final BoundaryDecisionType type;
  final BoundaryReasonCode reasonCode;
  final bool auditRequired;
  final BoundarySafeUserMessageKey safeUserMessageKey;

  bool get isAllowed => type == BoundaryDecisionType.allow;

  @override
  List<Object?> get props => [
    type,
    reasonCode,
    auditRequired,
    safeUserMessageKey,
  ];
}
