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
import { requireIdempotencyKey } from "../_shared/idempotency_key.ts";
import { parseRequestBody, sanitizeCreatedSession } from "./contract.ts";
import {
  type CreateSessionErrorCode,
  errorCodeFrom,
  errorResponse,
} from "./errors.ts";
import { type LogWriter, safeLog } from "./safe_log.ts";

const OPERATION = "createOwnChatSession";
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

function privilegedHeaders(serviceRoleKey: string): HeadersInit {
  return {
    apikey: serviceRoleKey,
    authorization: `Bearer ${serviceRoleKey}`,
    accept: "application/json",
  };
}

function mapRpcErrorBody(body: unknown): CreateSessionErrorCode {
  const message = typeof body === "object" && body !== null &&
      !Array.isArray(body) &&
      typeof (body as Record<string, unknown>).message === "string"
    ? String((body as Record<string, unknown>).message)
    : "";
  if (message.includes("idempotency_conflict")) return "idempotencyConflict";
  if (message.includes("invalid_idempotency_key")) {
    return "invalidIdempotencyKey";
  }
  if (message.includes("operation_in_progress")) return "operationInProgress";
  if (message.includes("invalid_selectable_specialist")) {
    return "invalidSelectableSpecialist";
  }
  if (message.includes("specialist_unavailable")) {
    return "specialistUnavailable";
  }
  if (message.includes("pro_locked")) return "proLocked";
  if (message.includes("permission_denied")) return "permissionDenied";
  if (message.includes("backend_misconfigured")) return "backendMisconfigured";
  if (message.includes("transaction_failed")) return "transactionFailed";
  if (message.includes("invalid_request")) return "invalidRequest";
  if (message.includes("permission denied")) return "permissionDenied";
  if (message.includes("function") || message.includes("schema cache")) {
    return "backendMisconfigured";
  }
  return "unexpectedError";
}

async function invokeCreateSessionRpc(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  ownerId: string,
  selectableId: string,
  idempotencyKey: string,
): Promise<unknown> {
  const url = new URL("/rest/v1/rpc/create_own_chat_session_core", baseUrl);
  const response = await fetcher(url, {
    method: "POST",
    headers: {
      ...privilegedHeaders(serviceRoleKey),
      "content-type": "application/json",
    },
    body: JSON.stringify({
      p_owner_user_id: ownerId,
      p_selectable_specialist_id: selectableId,
      p_idempotency_key: idempotencyKey,
    }),
  });
  if (!response.ok) {
    let body: unknown = null;
    try {
      body = await response.json();
    } catch {
      // Keep backend details opaque.
    }
    throw new Error(mapRpcErrorBody(body));
  }
  if (response.status === 204) throw new Error("contractViolation");
  return await response.json();
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
      const selectableId = await parseRequestBody(request);
      const idempotencyKey = requireIdempotencyKey(request);
      const authorization = await prepareBackendAuthorization({
        request,
        fetcher,
        config,
        operation: BACKEND_OPERATIONS.createOwnChatSession,
        generateCorrelationId: () => id,
      });
      id = authorization.context.correlationId;
      const baseUrl = authorization.baseUrl;
      const ownerId = authorization.identitySubjectId;
      const rows = await invokeCreateSessionRpc(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        ownerId,
        selectableId,
        idempotencyKey,
      );
      const sanitized = sanitizeCreatedSession(rows);
      finalizeBackendAuthorization(
        authorization,
        BACKEND_OPERATIONS.createOwnChatSession,
        "owned",
      );
      result = "success";
      return Response.json(
        { session: sanitized.session },
        {
          status: sanitized.idempotentReplay ? 200 : 201,
          headers: {
            ...corsHeadersFor(request, config, METHODS),
            "cache-control": "no-store",
            "content-type": "application/json",
          },
        },
      );
    } catch (error) {
      return withCorsHeaders(
        errorResponse(errorCodeFrom(error), id),
        request,
        config,
        METHODS,
      );
    } finally {
      safeLog(
        {
          operation: OPERATION,
          result,
          latency: Math.max(0, now() - startedAt),
          contract_version: "1",
          request_id: id,
        },
        logWriter,
      );
    }
  };
}

if (import.meta.main) {
  Deno.serve(createHandler(readRuntimeConfig()));
}
