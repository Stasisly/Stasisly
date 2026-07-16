export type CreateSessionErrorCode =
  | "methodNotAllowed"
  | "unauthenticated"
  | "invalidSession"
  | "invalidRequest"
  | "missingIdempotencyKey"
  | "invalidIdempotencyKey"
  | "idempotencyConflict"
  | "operationInProgress"
  | "invalidSelectableSpecialist"
  | "specialistUnavailable"
  | "proLocked"
  | "permissionDenied"
  | "contractViolation"
  | "backendMisconfigured"
  | "transactionFailed"
  | "unexpectedError";

const ERROR_STATUS: Record<CreateSessionErrorCode, number> = {
  methodNotAllowed: 405,
  unauthenticated: 401,
  invalidSession: 401,
  invalidRequest: 400,
  missingIdempotencyKey: 400,
  invalidIdempotencyKey: 400,
  idempotencyConflict: 409,
  operationInProgress: 409,
  invalidSelectableSpecialist: 404,
  specialistUnavailable: 409,
  proLocked: 403,
  permissionDenied: 403,
  contractViolation: 502,
  backendMisconfigured: 500,
  transactionFailed: 503,
  unexpectedError: 500,
};

export function errorResponse(
  code: CreateSessionErrorCode,
  requestId: string,
): Response {
  return Response.json(
    { error: { code, requestId } },
    {
      status: ERROR_STATUS[code],
      headers: { "cache-control": "no-store" },
    },
  );
}

export function errorCodeFrom(error: unknown): CreateSessionErrorCode {
  const category = backendPublicErrorCategory(error);
  if (category === "unauthenticated") return "unauthenticated";
  if (category === "invalidAuthentication") return "invalidSession";
  if (category === "invalidRequest") return "invalidRequest";
  if (category === "permissionDenied") return "permissionDenied";
  if (category === "backendBlocked") return "backendMisconfigured";
  if (category === "unexpectedError") return "unexpectedError";
  if (error instanceof Error) {
    const candidate = error.message as CreateSessionErrorCode;
    if (candidate in ERROR_STATUS) return candidate;
  }
  return "unexpectedError";
}
import { backendPublicErrorCategory } from "../_shared/authorization/public_error_mapping.ts";
