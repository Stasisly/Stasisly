export type ListSessionsErrorCode =
  | "methodNotAllowed"
  | "unauthenticated"
  | "invalidSession"
  | "invalidRequest"
  | "invalidStatus"
  | "invalidCursor"
  | "permissionDenied"
  | "contractViolation"
  | "backendMisconfigured"
  | "unexpectedError";

const ERROR_STATUS: Record<ListSessionsErrorCode, number> = {
  methodNotAllowed: 405,
  unauthenticated: 401,
  invalidSession: 401,
  invalidRequest: 400,
  invalidStatus: 400,
  invalidCursor: 400,
  permissionDenied: 403,
  contractViolation: 502,
  backendMisconfigured: 503,
  unexpectedError: 500,
};

export function errorResponse(
  code: ListSessionsErrorCode,
  requestId: string,
): Response {
  return Response.json(
    { error: { code, requestId } },
    { status: ERROR_STATUS[code], headers: { "cache-control": "no-store" } },
  );
}

export function errorCodeFrom(error: unknown): ListSessionsErrorCode {
  const category = backendPublicErrorCategory(error);
  if (category === "unauthenticated") return "unauthenticated";
  if (category === "invalidAuthentication") return "invalidSession";
  if (category === "invalidRequest") return "invalidRequest";
  if (category === "permissionDenied") return "permissionDenied";
  if (category === "backendBlocked") return "backendMisconfigured";
  if (category === "unexpectedError") return "unexpectedError";
  if (error instanceof Error) {
    const candidate = error.message as ListSessionsErrorCode;
    if (candidate in ERROR_STATUS) return candidate;
  }
  return "unexpectedError";
}
import { backendPublicErrorCategory } from "../_shared/authorization/public_error_mapping.ts";
