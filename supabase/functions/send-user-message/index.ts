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
import {
  parseSendMessageBody,
  sanitizeRpcResult,
  type SendMessageCommand,
} from "./contract.ts";
import {
  errorCodeFrom,
  errorResponse,
  type SendMessageErrorCode,
} from "./errors.ts";
import { type LogWriter, safeLog } from "./safe_log.ts";

const OPERATION = "sendUserMessage";
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
  input: URL,
  init: RequestInit,
  errorCode: SendMessageErrorCode,
): Promise<unknown> {
  const response = await fetcher(input, init);
  if (!response.ok) throw new Error(errorCode);
  if (response.status === 204) throw new Error("contractViolation");
  return await response.json();
}

function privilegedHeaders(serviceRoleKey: string): HeadersInit {
  return {
    apikey: serviceRoleKey,
    authorization: `Bearer ${serviceRoleKey}`,
    accept: "application/json",
  };
}

function mapRpcErrorBody(body: unknown): SendMessageErrorCode {
  const message = typeof body === "object" && body !== null &&
      !Array.isArray(body) &&
      typeof (body as Record<string, unknown>).message === "string"
    ? String((body as Record<string, unknown>).message)
    : "";
  if (message.includes("content_too_long")) return "contentTooLong";
  if (message.includes("idempotency_conflict")) return "idempotencyConflict";
  if (message.includes("invalid_idempotency_key")) {
    return "invalidIdempotencyKey";
  }
  if (message.includes("operation_in_progress")) return "operationInProgress";
  if (message.includes("transaction_failed")) return "transactionFailed";
  if (message.includes("content_invalid")) return "contentInvalid";
  if (message.includes("session_archived")) return "sessionArchived";
  if (message.includes("session_not_found")) return "sessionNotFound";
  if (message.includes("invalid_request")) return "invalidRequest";
  if (message.includes("write_unconfirmed")) return "writeUnconfirmed";
  if (message.includes("permission denied")) return "permissionDenied";
  if (message.includes("function") || message.includes("schema cache")) {
    return "backendMisconfigured";
  }
  return "unexpectedError";
}

async function invokeSendMessageRpc(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  ownerId: string,
  command: SendMessageCommand,
  idempotencyKey: string,
): Promise<unknown> {
  const url = new URL("/rest/v1/rpc/send_user_message_core", baseUrl);
  const response = await fetcher(url, {
    method: "POST",
    headers: {
      ...privilegedHeaders(serviceRoleKey),
      "content-type": "application/json",
    },
    body: JSON.stringify({
      p_session_id: command.sessionId,
      p_owner_user_id: ownerId,
      p_content: command.content,
      p_idempotency_key: idempotencyKey,
    }),
  });
  if (!response.ok) {
    let body: unknown = null;
    try {
      body = await response.json();
    } catch {
      // Keep response body opaque and map by status below.
    }
    if (response.status === 401) throw new Error("invalidSession");
    if (response.status === 403) throw new Error("permissionDenied");
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
    let errorCode: SendMessageErrorCode | undefined;
    try {
      if (request.method !== "POST") throw new Error("methodNotAllowed");
      const command = await parseSendMessageBody(request);
      const idempotencyKey = requireIdempotencyKey(request);
      const authorization = await prepareBackendAuthorization({
        request,
        fetcher,
        config,
        operation: BACKEND_OPERATIONS.sendUserMessage,
        generateCorrelationId: () => id,
        resourceId: command.sessionId,
      });
      id = authorization.context.correlationId;
      const baseUrl = authorization.baseUrl;
      const ownerId = authorization.identitySubjectId;
      const rows = await invokeSendMessageRpc(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        ownerId,
        command,
        idempotencyKey,
      );
      const sanitized = sanitizeRpcResult(rows);
      finalizeBackendAuthorization(
        authorization,
        BACKEND_OPERATIONS.sendUserMessage,
        "owned",
      );
      result = "success";
      return Response.json(sanitized.payload, {
        status: sanitized.idempotentReplay ? 200 : 201,
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
        contract_version: "1",
        request_id: id,
        ...(errorCode ? { error_code: errorCode } : {}),
      }, logWriter);
    }
  };
}

if (import.meta.main) Deno.serve(createHandler(readRuntimeConfig()));
