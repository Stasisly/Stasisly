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
import { parseArchiveBody, sanitizeArchiveResult } from "./contract.ts";
import {
  type ArchiveErrorCode,
  errorCodeFrom,
  errorResponse,
} from "./errors.ts";
import { type LogWriter, safeLog } from "./safe_log.ts";

const OPERATION = "archiveOwnChatSession";
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
  error: ArchiveErrorCode,
): Promise<unknown> {
  const response = await fetcher(url, init);
  if (!response.ok) {
    let body: unknown = null;
    try {
      body = await response.json();
    } catch {
      throw new Error(error);
    }
    const message = typeof body === "object" && body !== null &&
        typeof (body as Record<string, unknown>).message === "string"
      ? String((body as Record<string, unknown>).message)
      : "";
    if (message.includes("conversation_not_found")) {
      throw new Error("sessionNotFound");
    }
    if (message.includes("invalid_lifecycle")) {
      throw new Error("contractViolation");
    }
    throw new Error(error);
  }
  if (response.status === 204) throw new Error("archiveUnconfirmed");
  return await response.json();
}

async function archiveOwnSession(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  ownerId: string,
  sessionId: string,
): Promise<unknown> {
  const url = new URL("/rest/v1/rpc/archive_own_conversation_core", baseUrl);
  return await requestJson(
    fetcher,
    url,
    {
      method: "POST",
      headers: {
        apikey: serviceRoleKey,
        authorization: `Bearer ${serviceRoleKey}`,
        accept: "application/json",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        p_owner_user_id: ownerId,
        p_conversation_id: sessionId,
      }),
    },
    "backendMisconfigured",
  );
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
    let result: "success" | "error" = "error";
    try {
      if (request.method !== "POST") throw new Error("methodNotAllowed");
      const sessionId = await parseArchiveBody(request);
      const authorization = await prepareBackendAuthorization({
        request,
        fetcher,
        config,
        operation: BACKEND_OPERATIONS.archiveOwnChatSession,
        generateCorrelationId: () => id,
        resourceId: sessionId,
      });
      id = authorization.context.correlationId;
      const baseUrl = authorization.baseUrl;
      const ownerId = authorization.identitySubjectId;
      const rows = await archiveOwnSession(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        ownerId,
        sessionId,
      );
      const session = sanitizeArchiveResult(rows, sessionId);
      finalizeBackendAuthorization(
        authorization,
        BACKEND_OPERATIONS.archiveOwnChatSession,
        "owned",
      );
      result = "success";
      return Response.json({ session }, {
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
        contract_version: "1",
        request_id: id,
      }, logWriter);
    }
  };
}

if (import.meta.main) Deno.serve(createHandler(readRuntimeConfig()));
