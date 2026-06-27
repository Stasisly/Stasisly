export type ListMessagesErrorCode =
  | "methodNotAllowed"
  | "unauthenticated"
  | "invalidSession"
  | "invalidRequest"
  | "invalidCursor"
  | "sessionNotFound"
  | "permissionDenied"
  | "contractViolation"
  | "backendMisconfigured"
  | "unexpectedError";

const ERROR_STATUS: Record<ListMessagesErrorCode, number> = {
  methodNotAllowed: 405,
  unauthenticated: 401,
  invalidSession: 401,
  invalidRequest: 400,
  invalidCursor: 400,
  sessionNotFound: 404,
  permissionDenied: 403,
  contractViolation: 502,
  backendMisconfigured: 503,
  unexpectedError: 500,
};

export function errorResponse(
  code: ListMessagesErrorCode,
  requestId: string,
): Response {
  return Response.json(
    { error: { code, requestId } },
    { status: ERROR_STATUS[code], headers: { "cache-control": "no-store" } },
  );
}

export function errorCodeFrom(error: unknown): ListMessagesErrorCode {
  if (error instanceof Error) {
    const candidate = error.message as ListMessagesErrorCode;
    if (candidate in ERROR_STATUS) return candidate;
  }
  return "unexpectedError";
}
