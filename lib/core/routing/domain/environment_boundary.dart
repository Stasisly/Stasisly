import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';

class EnvironmentBoundary {
  const EnvironmentBoundary();

  BoundaryDecision evaluate({
    required AuthorizationEnvironment actual,
    required Set<AuthorizationEnvironment> allowed,
    required bool remotePermissionGranted,
  }) {
    if (actual == AuthorizationEnvironment.unknown) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.blockedByEnvironment,
        reasonCode: BoundaryReasonCode.unknownEnvironment,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.environmentBlocked,
      );
    }
    if (!allowed.contains(actual)) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.blockedByEnvironment,
        reasonCode: BoundaryReasonCode.environmentMismatch,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.environmentBlocked,
      );
    }

    // The flag is explicit context for future remote-only boundaries. It never
    // widens an allowlist or remaps one environment to another.
    final _ = remotePermissionGranted;
    return const BoundaryDecision(
      type: BoundaryDecisionType.allow,
      reasonCode: BoundaryReasonCode.allowed,
      auditRequired: false,
      safeUserMessageKey: BoundarySafeUserMessageKey.none,
    );
  }
}
