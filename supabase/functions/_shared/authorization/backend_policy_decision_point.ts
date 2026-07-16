import type { BackendAuthorizationDecision } from "./backend_authorization_decision.ts";
import type { BackendOperationDefinition } from "./backend_operation_definition.ts";
import type { BackendRequestContext } from "./backend_request_context.ts";

export type BackendAuthorizationPhase = "preflight" | "final";

export interface BackendAuthorizationPolicyDecisionPoint {
  decide(
    context: BackendRequestContext,
    operation: BackendOperationDefinition,
    phase: BackendAuthorizationPhase,
  ): BackendAuthorizationDecision;
}
