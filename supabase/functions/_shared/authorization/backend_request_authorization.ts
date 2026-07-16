import {
  localBackendAuthorizationEnforcer,
} from "./backend_authorization_enforcer.ts";
import type { BackendOperationDefinition } from "./backend_operation_definition.ts";
import {
  type BackendRequestContext,
  buildBackendRequestContext,
  withOwnershipState,
} from "./backend_request_context.ts";
import { verifyBackendHumanIdentity } from "./backend_identity.ts";
import type { BackendOwnershipState } from "./foundation_vocabulary.ts";
import {
  assertNoClientAuthorityMetadata,
  resolveCorrelationId,
} from "./request_metadata.ts";
import {
  resolveAllowedRuntime,
  type RuntimeGuardConfig,
} from "../runtime_guard.ts";

export interface PreparedBackendAuthorization {
  readonly baseUrl: URL;
  readonly context: BackendRequestContext;
  readonly identitySubjectId: string;
}

export async function prepareBackendAuthorization(input: {
  request: Request;
  fetcher: typeof fetch;
  config: RuntimeGuardConfig;
  operation: BackendOperationDefinition;
  generateCorrelationId: () => string;
  resourceId?: string;
}): Promise<PreparedBackendAuthorization> {
  assertNoClientAuthorityMetadata(input.request);
  const correlationId = resolveCorrelationId(
    input.request,
    input.generateCorrelationId,
  );
  const runtime = resolveAllowedRuntime(input.config);
  const identity = await verifyBackendHumanIdentity(
    input.request,
    input.fetcher,
    runtime.baseUrl,
    input.config.anonKey,
  );
  const context = buildBackendRequestContext({
    operation: input.operation,
    environment: runtime.environment,
    identity,
    correlationId,
    ...(input.resourceId ? { resourceId: input.resourceId } : {}),
    ownershipState: input.operation.ownershipRequired
      ? "unknown"
      : "notApplicable",
  });
  localBackendAuthorizationEnforcer.enforce(
    context,
    input.operation,
    "preflight",
  );
  if (!input.operation.ownershipRequired) {
    localBackendAuthorizationEnforcer.enforce(
      context,
      input.operation,
      "final",
    );
  }
  return Object.freeze({
    baseUrl: runtime.baseUrl,
    context,
    identitySubjectId: identity.subjectId,
  });
}

export function finalizeBackendAuthorization(
  prepared: PreparedBackendAuthorization,
  operation: BackendOperationDefinition,
  ownershipState: BackendOwnershipState,
): BackendRequestContext {
  const context = withOwnershipState(prepared.context, ownershipState);
  localBackendAuthorizationEnforcer.enforce(context, operation, "final");
  return context;
}
