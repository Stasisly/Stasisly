import { BackendAuthorizationError } from "./backend_authorization_decision.ts";

const AUTHORITY_KEYS = new Set([
  "environment",
  "entitlement",
  "owner",
  "ownerid",
  "owneruserid",
  "role",
  "roles",
  "surface",
  "user_id",
  "userid",
]);

const AUTHORITY_HEADERS = new Set([
  "environment",
  "entitlement",
  "owner",
  "owner-id",
  "role",
  "surface",
  "user-id",
  "x-environment",
  "x-entitlement",
  "x-owner-id",
  "x-role",
  "x-stasisly-environment",
  "x-stasisly-surface",
  "x-surface",
  "x-user-id",
]);

const CORRELATION_PATTERN = /^[A-Za-z0-9][A-Za-z0-9._:-]{0,63}$/u;

export function assertNoClientAuthorityMetadata(request: Request): void {
  for (const [name] of request.headers) {
    if (AUTHORITY_HEADERS.has(name.toLowerCase())) {
      throw new BackendAuthorizationError("unexpectedAuthorityField");
    }
  }
  for (const name of new URL(request.url).searchParams.keys()) {
    if (AUTHORITY_KEYS.has(name.toLowerCase())) {
      throw new BackendAuthorizationError("unexpectedAuthorityField");
    }
  }
}

export function resolveCorrelationId(
  request: Request,
  generate: () => string,
): string {
  const supplied = request.headers.get("x-correlation-id");
  if (supplied === null) {
    const generated = generate();
    if (!CORRELATION_PATTERN.test(generated)) {
      throw new BackendAuthorizationError("invalidCorrelationId");
    }
    return generated;
  }
  if (!CORRELATION_PATTERN.test(supplied)) {
    throw new BackendAuthorizationError("invalidCorrelationId");
  }
  return supplied;
}
