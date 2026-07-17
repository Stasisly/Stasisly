import {
  corsHeadersFor,
  preflightResponse,
  withCorsHeaders,
} from "../_shared/cors.ts";
import { BACKEND_OPERATIONS } from "../_shared/authorization/backend_operation_definition.ts";
import {
  finalizeBackendAuthorization,
  prepareBackendAuthorization,
} from "../_shared/authorization/backend_request_authorization.ts";
import { assertAllowedRuntime } from "../_shared/runtime_guard.ts";
import {
  buildListResponse,
  type ListRequest,
  parseListRequest,
} from "./contract.ts";
import {
  errorCodeFrom,
  errorResponse,
  type ListSessionsErrorCode,
} from "./errors.ts";
import { type LogWriter, safeLog } from "./safe_log.ts";

const OPERATION = "listOwnChatSessions";
const METHODS = ["GET", "OPTIONS"];

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
  now?: () => number;
  requestId?: () => string;
  logWriter?: LogWriter;
}

export function readRuntimeConfig(): RuntimeConfig {
  return {
    supabaseUrl: Deno.env.get("SUPABASE_URL") ?? "",
    anonKey: Deno.env.get("SUPABASE_ANON_KEY") ?? "",
    serviceRoleKey: Deno.env.get("SUPABASE_SERVICE_ROLE_KEY") ?? "",
    allowLocalOnly: Deno.env.get("STASISLY_ALLOW_LOCAL_ONLY") ?? "",
    runtimeMode: Deno.env.get("STASISLY_RUNTIME_MODE") ?? "",
    allowDevelopmentRemote: Deno.env.get(
      "STASISLY_ALLOW_DEVELOPMENT_REMOTE",
    ) ?? "",
    corsAllowedOrigins: Deno.env.get("CORS_ALLOWED_ORIGINS") ?? "",
  };
}

export function assertLocalRuntime(config: RuntimeConfig): URL {
  return assertAllowedRuntime(config);
}

async function requestJson(
  fetcher: typeof fetch,
  url: URL,
  init: RequestInit,
  error: ListSessionsErrorCode,
): Promise<unknown> {
  const response = await fetcher(url, init);
  if (!response.ok || response.status === 204) throw new Error(error);
  return await response.json();
}

function privilegedHeaders(serviceRoleKey: string): HeadersInit {
  return {
    apikey: serviceRoleKey,
    authorization: `Bearer ${serviceRoleKey}`,
    accept: "application/json",
  };
}

function sessionsUrl(baseUrl: URL): URL {
  const url = new URL("/rest/v1/rpc/list_own_conversations_core", baseUrl);
  return url;
}

export function createHandler(
  config: RuntimeConfig,
  dependencies: HandlerDependencies = {},
): (request: Request) => Promise<Response> {
  const fetcher = dependencies.fetcher ?? fetch;
  const now = dependencies.now ?? Date.now;
  const requestId = dependencies.requestId ?? (() => crypto.randomUUID());
  const logWriter = dependencies.logWriter ?? console.log;

  return async (request: Request): Promise<Response> => {
    if (request.method === "OPTIONS") {
      return preflightResponse(request, config, METHODS);
    }
    const startedAt = now();
    let id = requestId();
    let count = 0;
    let result: "success" | "error" = "error";
    try {
      if (request.method !== "GET") throw new Error("methodNotAllowed");
      const listRequest = parseListRequest(new URL(request.url));
      const authorization = await prepareBackendAuthorization({
        request,
        fetcher,
        config,
        operation: BACKEND_OPERATIONS.listOwnChatSessions,
        generateCorrelationId: () => id,
      });
      id = authorization.context.correlationId;
      const baseUrl = authorization.baseUrl;
      const ownerId = authorization.identitySubjectId;
      const sessionRows = await requestJson(
        fetcher,
        sessionsUrl(baseUrl),
        {
          method: "POST",
          headers: {
            ...privilegedHeaders(config.serviceRoleKey),
            "content-type": "application/json",
          },
          body: JSON.stringify({
            p_owner_user_id: ownerId,
            p_status: listRequest.status,
            p_limit: listRequest.limit + 1,
            p_cursor_updated_at: listRequest.cursor?.lastMessageAt ?? null,
            p_cursor_id: listRequest.cursor?.sessionId ?? null,
          }),
        },
        "backendMisconfigured",
      );
      const response = buildListResponse(sessionRows, listRequest.limit);
      finalizeBackendAuthorization(
        authorization,
        BACKEND_OPERATIONS.listOwnChatSessions,
        "owned",
      );
      count = response.items.length;
      result = "success";
      return Response.json(response, {
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
    } finally {
      safeLog({
        operation: OPERATION,
        result,
        latency: Math.max(0, now() - startedAt),
        count,
        contract_version: "1",
        request_id: id,
      }, logWriter);
    }
  };
}

if (import.meta.main) Deno.serve(createHandler(readRuntimeConfig()));
