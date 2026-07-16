export type SendMessageErrorCode =
  | "methodNotAllowed"
  | "unauthenticated"
  | "invalidSession"
  | "invalidRequest"
  | "contentInvalid"
  | "contentTooLong"
  | "sessionNotFound"
  | "sessionArchived"
  | "permissionDenied"
  | "writeUnconfirmed"
  | "contractViolation"
  | "backendMisconfigured"
  | "unexpectedError";

const ERROR_STATUS: Record<SendMessageErrorCode, number> = {
  methodNotAllowed: 405,
  unauthenticated: 401,
  invalidSession: 401,
  invalidRequest: 400,
  contentInvalid: 400,
  contentTooLong: 400,
  sessionNotFound: 404,
  sessionArchived: 409,
  permissionDenied: 403,
  writeUnconfirmed: 409,
  contractViolation: 502,
  backendMisconfigured: 503,
  unexpectedError: 500,
};

export function errorResponse(
  code: SendMessageErrorCode,
  requestId: string,
): Response {
  return Response.json(
    { error: { code, requestId } },
    { status: ERROR_STATUS[code], headers: { "cache-control": "no-store" } },
  );
}

export function errorCodeFrom(error: unknown): SendMessageErrorCode {
  const category = backendPublicErrorCategory(error);
  if (category === "unauthenticated") return "unauthenticated";
  if (category === "invalidAuthentication") return "invalidSession";
  if (category === "invalidRequest") return "invalidRequest";
  if (category === "permissionDenied") return "permissionDenied";
  if (category === "backendBlocked") return "backendMisconfigured";
  if (category === "unexpectedError") return "unexpectedError";
  if (error instanceof Error) {
    const candidate = error.message as SendMessageErrorCode;
    if (candidate in ERROR_STATUS) return candidate;
  }
  return "unexpectedError";
}
import { backendPublicErrorCategory } from "../_shared/authorization/public_error_mapping.ts";
