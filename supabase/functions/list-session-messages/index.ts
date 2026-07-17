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
  buildMessagesResponse,
  type CursorValue,
  parseListMessagesRequest,
} from "./contract.ts";
import {
  errorCodeFrom,
  errorResponse,
  type ListMessagesErrorCode,
} from "./errors.ts";
import { type LogWriter, safeLog } from "./safe_log.ts";

const OPERATION = "conversation.message.listOwn";
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
  error: ListMessagesErrorCode,
): Promise<unknown> {
  const response = await fetcher(url, init);
  if (!response.ok) {
    let body: unknown = null;
    try {
      body = await response.json();
    } catch {
      // Keep database details opaque.
    }
    const message = typeof body === "object" && body !== null &&
        !Array.isArray(body) &&
        typeof (body as Record<string, unknown>).message === "string"
      ? String((body as Record<string, unknown>).message)
      : "";
    if (message.includes("session_not_found")) {
      throw new Error("sessionNotFound");
    }
    throw new Error(error);
  }
  if (response.status === 204) throw new Error(error);
  return await response.json();
}

function privilegedHeaders(serviceRoleKey: string): HeadersInit {
  return {
    apikey: serviceRoleKey,
    authorization: `Bearer ${serviceRoleKey}`,
    accept: "application/json",
  };
}

function messagesUrl(
  baseUrl: URL,
  ownerId: string,
  sessionId: string,
  limit: number,
  cursor?: CursorValue,
): URL {
  const url = new URL(
    "/rest/v1/rpc/list_own_conversation_messages_core",
    baseUrl,
  );
  url.searchParams.set("p_owner_user_id", ownerId);
  url.searchParams.set("p_session_id", sessionId);
  url.searchParams.set("p_limit", String(limit + 1));
  if (cursor) {
    url.searchParams.set("p_after_created_at", cursor.createdAt);
    url.searchParams.set("p_after_message_id", cursor.messageId);
  }
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
    let errorCode: ListMessagesErrorCode | undefined;
    try {
      if (request.method !== "GET") throw new Error("methodNotAllowed");
      const listRequest = parseListMessagesRequest(new URL(request.url));
      const authorization = await prepareBackendAuthorization({
        request,
        fetcher,
        config,
        operation: BACKEND_OPERATIONS.listSessionMessages,
        generateCorrelationId: () => id,
        resourceId: listRequest.sessionId,
      });
      id = authorization.context.correlationId;
      const baseUrl = authorization.baseUrl;
      const ownerId = authorization.identitySubjectId;
      const messageRows = await requestJson(
        fetcher,
        messagesUrl(
          baseUrl,
          ownerId,
          listRequest.sessionId,
          listRequest.limit,
          listRequest.cursor,
        ),
        { headers: privilegedHeaders(config.serviceRoleKey) },
        "backendMisconfigured",
      );
      finalizeBackendAuthorization(
        authorization,
        BACKEND_OPERATIONS.listSessionMessages,
        "owned",
      );
      const response = buildMessagesResponse(messageRows, listRequest.limit);
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
      errorCode = errorCodeFrom(error);
      return withCorsHeaders(
        errorResponse(errorCode, id),
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
        ...(errorCode ? { error_code: errorCode } : {}),
      }, logWriter);
    }
  };
}

if (import.meta.main) Deno.serve(createHandler(readRuntimeConfig()));
