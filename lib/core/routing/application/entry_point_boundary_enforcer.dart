import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/routing/domain/boundary_decision.dart';
import 'package:stasisly/core/routing/domain/entry_point_context.dart';
import 'package:stasisly/core/routing/domain/entry_point_definition.dart';
import 'package:stasisly/core/routing/domain/environment_boundary.dart';
import 'package:stasisly/core/routing/domain/surface_boundary.dart';

class EntryPointBoundaryEnforcer {
  const EntryPointBoundaryEnforcer({
    this.surfaceBoundary = const SurfaceBoundary(),
    this.environmentBoundary = const EnvironmentBoundary(),
  });

  final SurfaceBoundary surfaceBoundary;
  final EnvironmentBoundary environmentBoundary;

  BoundaryDecision evaluate({
    required EntryPointDefinition? definition,
    required AuthorizationSurface actualSurface,
    required AuthorizationEnvironment actualEnvironment,
    required bool isAuthenticated,
    required bool remotePermissionGranted,
    bool? foundationPolicyAllowed,
  }) {
    if (definition == null) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.deny,
        reasonCode: BoundaryReasonCode.missingMetadata,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.notAvailable,
      );
    }
    if (definition.id == EntryPointId.unknown) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.deny,
        reasonCode: BoundaryReasonCode.unknownEntryPoint,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.notAvailable,
      );
    }
    if (definition.legacyState == EntryPointLegacyState.legacyBlocked) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.legacyBlocked,
        reasonCode: BoundaryReasonCode.legacyCapability,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.legacyUnavailable,
      );
    }
    if (definition.legacyState == EntryPointLegacyState.notAvailable ||
        definition.surface == AuthorizationSurface.administration ||
        definition.surface == AuthorizationSurface.platform ||
        definition.surface == AuthorizationSurface.sharedInfrastructure) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.notAvailable,
        reasonCode: BoundaryReasonCode.capabilityNotAvailable,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.notAvailable,
      );
    }

    final surfaceDecision = surfaceBoundary.evaluate(
      expected: definition.surface,
      actual: actualSurface,
    );
    if (!surfaceDecision.isAllowed) return surfaceDecision;

    final environmentDecision = environmentBoundary.evaluate(
      actual: actualEnvironment,
      allowed: definition.allowedEnvironments,
      remotePermissionGranted: remotePermissionGranted,
    );
    if (!environmentDecision.isAllowed) return environmentDecision;

    if (definition.requiresRuntimeEnablement && !remotePermissionGranted) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.blockedByEnvironment,
        reasonCode: BoundaryReasonCode.environmentMismatch,
        auditRequired: true,
        safeUserMessageKey: BoundarySafeUserMessageKey.environmentBlocked,
      );
    }

    if (definition.authenticationRequirement ==
            EntryPointAuthenticationRequirement.authenticated &&
        !isAuthenticated) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.redirectToAuthentication,
        reasonCode: BoundaryReasonCode.authenticationRequired,
        auditRequired: false,
        safeUserMessageKey: BoundarySafeUserMessageKey.authenticationRequired,
      );
    }

    if (definition.authorizationRequirement ==
            EntryPointAuthorizationRequirement.foundationPolicy &&
        foundationPolicyAllowed != true) {
      return const BoundaryDecision(
        type: BoundaryDecisionType.deny,
        reasonCode: BoundaryReasonCode.policyDenied,
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
