import {
  assertBackendAuthorizationAllowed,
  type BackendAuthorizationDecision,
  denyDecision,
} from "./backend_authorization_decision.ts";
import type { BackendOperationDefinition } from "./backend_operation_definition.ts";
import type {
  BackendAuthorizationPhase,
  BackendAuthorizationPolicyDecisionPoint,
} from "./backend_policy_decision_point.ts";
import type { BackendRequestContext } from "./backend_request_context.ts";
import { FoundationLocalBackendPolicy } from "./foundation_local_policy.ts";

export class BackendAuthorizationEnforcer {
  constructor(
    private readonly policy: BackendAuthorizationPolicyDecisionPoint | null =
      new FoundationLocalBackendPolicy(),
  ) {}

  evaluate(
    context: BackendRequestContext,
    operation: BackendOperationDefinition,
    phase: BackendAuthorizationPhase = "final",
  ): BackendAuthorizationDecision {
    if (this.policy === null) return denyDecision("policyUnavailable");
    try {
      return this.policy.decide(context, operation, phase);
    } catch {
      return denyDecision("policyError");
    }
  }

  enforce(
    context: BackendRequestContext,
    operation: BackendOperationDefinition,
    phase: BackendAuthorizationPhase = "final",
  ): BackendAuthorizationDecision {
    const decision = this.evaluate(context, operation, phase);
    assertBackendAuthorizationAllowed(decision);
    return decision;
  }
}

export const localBackendAuthorizationEnforcer =
  new BackendAuthorizationEnforcer();
