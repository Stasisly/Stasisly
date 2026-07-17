import { BACKEND_OPERATIONS } from "../_shared/authorization/backend_operation_definition.ts";
import {
  finalizeBackendAuthorization,
  prepareBackendAuthorization,
} from "../_shared/authorization/backend_request_authorization.ts";
import {
  corsHeadersFor,
  preflightResponse,
  withCorsHeaders,
} from "../_shared/cors.ts";
import { parseConversationBody } from "../_shared/conversation_contract.ts";
import { assertAllowedRuntime } from "../_shared/runtime_guard.ts";
import { errorCodeFrom, errorResponse } from "./errors.ts";
const METHODS = ["POST", "OPTIONS"];
export interface RuntimeConfig {
  supabaseUrl: string;
  anonKey: string;
  serviceRoleKey: string;
  allowLocalOnly: string;
  runtimeMode: string;
  allowDevelopmentRemote: string;
  corsAllowedOrigins: string;
}
export interface HandlerDependencies {
  fetcher?: typeof fetch;
  requestId?: () => string;
}
export function readRuntimeConfig(): RuntimeConfig {
  return {
    supabaseUrl: Deno.env.get("SUPABASE_URL") ?? "",
    anonKey: Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    serviceRoleKey: Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    allowLocalOnly: Deno.env.get("STASISLY_ALLOW_LOCAL_ONLY") ?? "",
    runtimeMode: Deno.env.get("STASISLY_RUNTIME_MODE") ?? "",
    allowDevelopmentRemote: Deno.env.get("STASISLY_ALLOW_DEVELOPMENT_REMOTE") ??
      "",
    corsAllowedOrigins: Deno.env.get("CORS_ALLOWED_ORIGINS") ?? "",
  };
}
export function assertLocalRuntime(config: RuntimeConfig): URL {
  return assertAllowedRuntime(config);
}
async function invoke(
  fetcher: typeof fetch,
  baseUrl: URL,
  key: string,
  ownerId: string,
  conversationId: string,
): Promise<unknown> {
  const response = await fetcher(
    new URL("/rest/v1/rpc/restore_own_conversation_core", baseUrl),
    {
      method: "POST",
      headers: {
        apikey: key,
        authorization: `Bearer ${key}`,
        accept: "application/json",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        p_owner_user_id: ownerId,
        p_conversation_id: conversationId,
      }),
    },
  );
  if (!response.ok) {
    let message = "";
    try {
      message = String((await response.json()).message ?? "");
    } catch { /* opaque */ }
    if (message.includes("conversation_not_found")) {
      throw new Error("conversationNotFound");
    }
    if (message.includes("invalid_lifecycle")) {
      throw new Error("invalidLifecycle");
    }
    throw new Error("backendMisconfigured");
  }
  return await response.json();
}
function sanitize(
  rows: unknown,
  id: string,
): { conversationId: string; status: "active" } {
  if (
    !Array.isArray(rows) || rows.length !== 1 || typeof rows[0] !== "object" ||
    rows[0] === null || Array.isArray(rows[0])
  ) throw new Error("contractViolation");
  const row = rows[0] as Record<string, unknown>;
  if (
    Object.keys(row).sort().join() !== "conversation_id,status" ||
    row.conversation_id !== id || row.status !== "active"
  ) throw new Error("contractViolation");
  return { conversationId: id, status: "active" };
}
export function createHandler(
  config: RuntimeConfig,
  dependencies: HandlerDependencies = {},
): (request: Request) => Promise<Response> {
  const fetcher = dependencies.fetcher ?? fetch;
  const requestId = dependencies.requestId ?? (() => crypto.randomUUID());
  return async (request) => {
    if (request.method === "OPTIONS") {
      return preflightResponse(request, config, METHODS);
    }
    let id = requestId();
    try {
      if (request.method !== "POST") throw new Error("methodNotAllowed");
      const conversationId = await parseConversationBody(request);
      const authorization = await prepareBackendAuthorization({
        request,
        fetcher,
        config,
        operation: BACKEND_OPERATIONS.restoreOwnConversation,
        generateCorrelationId: () => id,
        resourceId: conversationId,
      });
      id = authorization.context.correlationId;
      const rows = await invoke(
        fetcher,
        authorization.baseUrl,
        config.serviceRoleKey,
        authorization.identitySubjectId,
        conversationId,
      );
      const conversation = sanitize(rows, conversationId);
      finalizeBackendAuthorization(
        authorization,
        BACKEND_OPERATIONS.restoreOwnConversation,
        "owned",
      );
      return Response.json({ conversation }, {
        status: 200,
        headers: {
          ...corsHeadersFor(request, config, METHODS),
          "cache-control": "no-store",
          "content-type": "application/json",
        },
      });
    } catch (error) {
      return withCorsHeaders(
        errorResponse(errorCodeFrom(error), id),
        request,
        config,
        METHODS,
      );
    }
  };
}
if (import.meta.main) Deno.serve(createHandler(readRuntimeConfig()));
