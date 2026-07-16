export type BackendAuthorizationDecisionType =
  | "allow"
  | "deny"
  | "requireElevation"
  | "requireApproval"
  | "requireUserConsent"
  | "notApplicable";

export type BackendAuthorizationReasonCode =
  | "allowed"
  | "unauthenticated"
  | "invalidAuthentication"
  | "missingAuthorizationContext"
  | "unknownSurface"
  | "surfaceMismatch"
  | "unknownEnvironment"
  | "environmentBlocked"
  | "unknownAction"
  | "unknownResource"
  | "ownershipRequired"
  | "ownershipMismatch"
  | "unexpectedAuthorityField"
  | "invalidCorrelationId"
  | "operationNotRegistered"
  | "policyUnavailable"
  | "policyError"
  | "explicitDeny";

export interface BackendAuthorizationDecision {
  readonly type: BackendAuthorizationDecisionType;
  readonly reasonCode: BackendAuthorizationReasonCode;
  readonly auditRequired: boolean;
}

export class BackendAuthorizationError extends Error {
  constructor(readonly reasonCode: BackendAuthorizationReasonCode) {
    super(reasonCode);
    this.name = "BackendAuthorizationError";
  }
}

export function allowDecision(
  auditRequired: boolean,
): BackendAuthorizationDecision {
  return Object.freeze({
    type: "allow",
    reasonCode: "allowed",
    auditRequired,
  });
}

export function denyDecision(
  reasonCode: BackendAuthorizationReasonCode,
  auditRequired = true,
): BackendAuthorizationDecision {
  return Object.freeze({ type: "deny", reasonCode, auditRequired });
}

export function assertBackendAuthorizationAllowed(
  decision: BackendAuthorizationDecision,
): void {
  if (decision.type !== "allow") {
    throw new BackendAuthorizationError(decision.reasonCode);
  }
}
