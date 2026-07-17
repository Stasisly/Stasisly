import { backendPublicErrorCategory } from "../_shared/authorization/public_error_mapping.ts";
export type ErrorCode =
  | "methodNotAllowed"
  | "unauthenticated"
  | "invalidSession"
  | "invalidRequest"
  | "conversationNotFound"
  | "permissionDenied"
  | "invalidLifecycle"
  | "contractViolation"
  | "backendMisconfigured"
  | "unexpectedError";
const STATUS: Record<ErrorCode, number> = {
  methodNotAllowed: 405,
  unauthenticated: 401,
  invalidSession: 401,
  invalidRequest: 400,
  conversationNotFound: 404,
  permissionDenied: 403,
  invalidLifecycle: 409,
  contractViolation: 502,
  backendMisconfigured: 503,
  unexpectedError: 500,
};
export function errorResponse(code: ErrorCode, requestId: string): Response {
  return Response.json({ error: { code, requestId } }, {
    status: STATUS[code],
    headers: { "cache-control": "no-store" },
  });
}
export function errorCodeFrom(error: unknown): ErrorCode {
  const category = backendPublicErrorCategory(error);
  if (category === "unauthenticated") return "unauthenticated";
  if (category === "invalidAuthentication") return "invalidSession";
  if (category === "invalidRequest") return "invalidRequest";
  if (category === "permissionDenied") return "permissionDenied";
  if (category === "backendBlocked") return "backendMisconfigured";
  if (error instanceof Error && error.message in STATUS) {
    return error.message as ErrorCode;
  }
  return "unexpectedError";
}
