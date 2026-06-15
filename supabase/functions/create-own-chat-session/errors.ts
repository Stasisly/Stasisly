export type CreateSessionErrorCode =
  | "methodNotAllowed"
  | "unauthenticated"
  | "invalidSession"
  | "invalidRequest"
  | "invalidSelectableSpecialist"
  | "specialistUnavailable"
  | "premiumLocked"
  | "permissionDenied"
  | "contractViolation"
  | "backendMisconfigured"
  | "unexpectedError";

const ERROR_STATUS: Record<CreateSessionErrorCode, number> = {
  methodNotAllowed: 405,
  unauthenticated: 401,
  invalidSession: 401,
  invalidRequest: 400,
  invalidSelectableSpecialist: 404,
  specialistUnavailable: 409,
  premiumLocked: 403,
  permissionDenied: 403,
  contractViolation: 502,
  backendMisconfigured: 500,
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
  if (error instanceof Error) {
    const candidate = error.message as CreateSessionErrorCode;
    if (candidate in ERROR_STATUS) return candidate;
  }
  return "unexpectedError";
}
