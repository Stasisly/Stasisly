import {
  BackendAuthorizationError,
  type BackendAuthorizationReasonCode,
} from "./backend_authorization_decision.ts";

export type BackendPublicErrorCategory =
  | "unauthenticated"
  | "invalidAuthentication"
  | "invalidRequest"
  | "permissionDenied"
  | "backendBlocked"
  | "unexpectedError";

const PUBLIC_CATEGORY: Record<
  BackendAuthorizationReasonCode,
  BackendPublicErrorCategory
> = {
  allowed: "unexpectedError",
  unauthenticated: "unauthenticated",
  invalidAuthentication: "invalidAuthentication",
  missingAuthorizationContext: "permissionDenied",
  unknownSurface: "permissionDenied",
  surfaceMismatch: "permissionDenied",
  unknownEnvironment: "backendBlocked",
  environmentBlocked: "backendBlocked",
  unknownAction: "permissionDenied",
  unknownResource: "permissionDenied",
  ownershipRequired: "permissionDenied",
  ownershipMismatch: "permissionDenied",
  unexpectedAuthorityField: "invalidRequest",
  invalidCorrelationId: "invalidRequest",
  operationNotRegistered: "backendBlocked",
  policyUnavailable: "backendBlocked",
  policyError: "backendBlocked",
  explicitDeny: "permissionDenied",
};

export function backendPublicErrorCategory(
  error: unknown,
): BackendPublicErrorCategory | undefined {
  return error instanceof BackendAuthorizationError
    ? PUBLIC_CATEGORY[error.reasonCode]
    : undefined;
}
