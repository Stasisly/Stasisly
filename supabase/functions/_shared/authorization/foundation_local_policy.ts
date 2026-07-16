import {
  allowDecision,
  type BackendAuthorizationDecision,
  denyDecision,
} from "./backend_authorization_decision.ts";
import {
  type BackendOperationDefinition,
  isRegisteredOperation,
} from "./backend_operation_definition.ts";
import type {
  BackendAuthorizationPhase,
  BackendAuthorizationPolicyDecisionPoint,
} from "./backend_policy_decision_point.ts";
import type { BackendRequestContext } from "./backend_request_context.ts";

export class FoundationLocalBackendPolicy
  implements BackendAuthorizationPolicyDecisionPoint {
  decide(
    context: BackendRequestContext,
    operation: BackendOperationDefinition,
    phase: BackendAuthorizationPhase,
  ): BackendAuthorizationDecision {
    if (!isRegisteredOperation(operation)) {
      return denyDecision("operationNotRegistered");
    }
    if (
      context.authenticationState !== "authenticated" ||
      context.identityType !== "human" ||
      !context.identitySubjectId
    ) {
      return denyDecision(
        context.authenticationState === "unauthenticated"
          ? "unauthenticated"
          : "invalidAuthentication",
      );
    }
    if (context.requestSource !== "edgeFunction" || !context.correlationId) {
      return denyDecision("missingAuthorizationContext");
    }
    if (context.surface === "unknown") return denyDecision("unknownSurface");
    if (context.surface !== operation.expectedSurface) {
      return denyDecision("surfaceMismatch");
    }
    if (context.environment === "unknown") {
      return denyDecision("unknownEnvironment");
    }
    if (!operation.allowedEnvironments.includes(context.environment)) {
      return denyDecision("environmentBlocked");
    }
    if (context.action === "unknown") return denyDecision("unknownAction");
    if (context.action !== operation.action) {
      return denyDecision("explicitDeny");
    }
    if (context.resourceType === "unknown") {
      return denyDecision("unknownResource");
    }
    if (context.resourceType !== operation.resourceType) {
      return denyDecision("explicitDeny");
    }
    if (phase === "final" && operation.ownershipRequired) {
      if (context.ownershipState === "unknown") {
        return denyDecision("ownershipRequired");
      }
      if (context.ownershipState !== "owned") {
        return denyDecision("ownershipMismatch");
      }
    }
    if (
      !operation.ownershipRequired && context.ownershipState !== "notApplicable"
    ) {
      return denyDecision("explicitDeny");
    }
    return allowDecision(operation.auditRequired);
  }
}
