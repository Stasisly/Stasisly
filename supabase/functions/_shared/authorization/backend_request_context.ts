import type { BackendOperationDefinition } from "./backend_operation_definition.ts";
import type {
  BackendAuthenticationState,
  BackendIdentityType,
  BackendOwnershipState,
  BackendRequestSource,
  FoundationAction,
  FoundationEnvironment,
  FoundationResourceType,
  FoundationSurface,
} from "./foundation_vocabulary.ts";

export interface BackendRequestContext {
  readonly identitySubjectId: string | null;
  readonly identityType: BackendIdentityType;
  readonly authenticationState: BackendAuthenticationState;
  readonly surface: FoundationSurface;
  readonly environment: FoundationEnvironment;
  readonly action: FoundationAction;
  readonly resourceType: FoundationResourceType;
  readonly resourceId?: string;
  readonly ownershipState: BackendOwnershipState;
  readonly correlationId: string;
  readonly requestSource: BackendRequestSource;
}

export interface VerifiedBackendIdentity {
  readonly subjectId: string;
  readonly identityType: "human";
  readonly authenticationState: "authenticated";
}

export function buildBackendRequestContext(input: {
  operation: BackendOperationDefinition;
  environment: FoundationEnvironment;
  identity: VerifiedBackendIdentity;
  correlationId: string;
  resourceId?: string;
  ownershipState?: BackendOwnershipState;
}): BackendRequestContext {
  return Object.freeze({
    identitySubjectId: input.identity.subjectId,
    identityType: input.identity.identityType,
    authenticationState: input.identity.authenticationState,
    surface: input.operation.expectedSurface,
    environment: input.environment,
    action: input.operation.action,
    resourceType: input.operation.resourceType,
    ...(input.resourceId ? { resourceId: input.resourceId } : {}),
    ownershipState: input.ownershipState ?? "unknown",
    correlationId: input.correlationId,
    requestSource: "edgeFunction",
  });
}

export function withOwnershipState(
  context: BackendRequestContext,
  ownershipState: BackendOwnershipState,
): BackendRequestContext {
  return Object.freeze({ ...context, ownershipState });
}
