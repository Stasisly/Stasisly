export type CatalogErrorCode =
  | "catalogMethodNotAllowed"
  | "catalogInvalidRequest"
  | "catalogInvalidArea"
  | "catalogUnauthenticated"
  | "catalogBackendBlocked"
  | "catalogContractViolation"
  | "catalogUnexpectedFailure";

const ERROR_STATUS: Record<CatalogErrorCode, number> = {
  catalogMethodNotAllowed: 405,
  catalogInvalidRequest: 400,
  catalogInvalidArea: 400,
  catalogUnauthenticated: 401,
  catalogBackendBlocked: 503,
  catalogContractViolation: 500,
  catalogUnexpectedFailure: 500,
};

export function errorResponse(
  code: CatalogErrorCode,
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

export function errorCodeFrom(error: unknown): CatalogErrorCode {
  const category = backendPublicErrorCategory(error);
  if (category === "unauthenticated" || category === "invalidAuthentication") {
    return "catalogUnauthenticated";
  }
  if (category === "invalidRequest") return "catalogInvalidRequest";
  if (category === "permissionDenied" || category === "backendBlocked") {
    return "catalogBackendBlocked";
  }
  if (category === "unexpectedError") return "catalogUnexpectedFailure";
  if (error instanceof Error) {
    const candidate = error.message as CatalogErrorCode;
    if (candidate in ERROR_STATUS) return candidate;
  }
  return "catalogUnexpectedFailure";
}
import { backendPublicErrorCategory } from "../_shared/authorization/public_error_mapping.ts";
