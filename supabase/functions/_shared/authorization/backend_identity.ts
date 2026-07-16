import { BackendAuthorizationError } from "./backend_authorization_decision.ts";
import type { VerifiedBackendIdentity } from "./backend_request_context.ts";

function bearerToken(request: Request): string {
  const match = /^Bearer ([^\s]+)$/u.exec(
    request.headers.get("authorization") ?? "",
  );
  if (!match) throw new BackendAuthorizationError("unauthenticated");
  return match[1];
}

export async function verifyBackendHumanIdentity(
  request: Request,
  fetcher: typeof fetch,
  baseUrl: URL,
  anonKey: string,
): Promise<VerifiedBackendIdentity> {
  const response = await fetcher(new URL("/auth/v1/user", baseUrl), {
    headers: {
      apikey: anonKey,
      authorization: `Bearer ${bearerToken(request)}`,
    },
  });
  if (!response.ok) {
    throw new BackendAuthorizationError("invalidAuthentication");
  }
  let body: unknown;
  try {
    body = await response.json();
  } catch {
    throw new BackendAuthorizationError("invalidAuthentication");
  }
  if (
    typeof body !== "object" || body === null || Array.isArray(body) ||
    typeof (body as Record<string, unknown>).id !== "string" ||
    (body as Record<string, string>).id.length === 0
  ) {
    throw new BackendAuthorizationError("invalidAuthentication");
  }
  return Object.freeze({
    subjectId: (body as Record<string, string>).id,
    identityType: "human",
    authenticationState: "authenticated",
  });
}
