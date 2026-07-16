import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';

class SurfaceBoundary {
  const SurfaceBoundary();

  BoundaryDecision evaluate({
    required AuthorizationSurface expected,
    required AuthorizationSurface actual,
  }) {
    if (expected == AuthorizationSurface.unknown ||
        actual == AuthorizationSurface.unknown) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.blockedBySurface,
        reasonCode: BoundaryReasonCode.unknownSurface,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.accessDenied,
      );
    }
    if (expected != actual) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.blockedBySurface,
        reasonCode: BoundaryReasonCode.surfaceMismatch,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.accessDenied,
      );
    }
    return const BoundaryDecision(
      type: BoundaryDecisionType.allow,
      reasonCode: BoundaryReasonCode.allowed,
      auditRequired: false,
      safeUserMessageKey: BoundarySafeUserMessageKey.none,
    );
  }
}
