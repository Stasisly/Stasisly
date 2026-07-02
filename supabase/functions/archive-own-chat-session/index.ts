import {
  corsHeadersFor,
  preflightResponse,
  withCorsHeaders,
} from "../_shared/cors.ts";
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

function bearerToken(request: Request): string {
  const match = /^Bearer ([^\s]+)$/u.exec(
    request.headers.get("authorization") ?? "",
  );
  if (!match) throw new Error("unauthenticated");
  return match[1];
}

async function requestJson(
  fetcher: typeof fetch,
  url: URL,
  init: RequestInit,
  error: ArchiveErrorCode,
): Promise<unknown> {
  const response = await fetcher(url, init);
  if (!response.ok) throw new Error(error);
  if (response.status === 204) throw new Error("archiveUnconfirmed");
  return await response.json();
}

async function validateLocalUser(
  fetcher: typeof fetch,
  baseUrl: URL,
  anonKey: string,
  token: string,
): Promise<string> {
  const body = await requestJson(
    fetcher,
    new URL("/auth/v1/user", baseUrl),
    { headers: { apikey: anonKey, authorization: `Bearer ${token}` } },
    "invalidSession",
  );
  if (
    typeof body !== "object" || body === null || Array.isArray(body) ||
    typeof (body as Record<string, unknown>).id !== "string"
  ) throw new Error("invalidSession");
  return (body as Record<string, string>).id;
}

async function archiveOwnSession(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  ownerId: string,
  sessionId: string,
): Promise<unknown> {
  const url = new URL("/rest/v1/chat_sessions", baseUrl);
  url.searchParams.set("select", "id,status");
  url.searchParams.set("id", `eq.${sessionId}`);
  url.searchParams.set("user_id", `eq.${ownerId}`);
  url.searchParams.set("status", "eq.active");
  return await requestJson(
    fetcher,
    url,
    {
      method: "PATCH",
      headers: {
        apikey: serviceRoleKey,
        authorization: `Bearer ${serviceRoleKey}`,
        accept: "application/json",
        "content-type": "application/json",
        prefer: "return=representation",
      },
      body: JSON.stringify({ status: "archived" }),
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
    const id = requestId();
    let result: "success" | "error" = "error";
    try {
      if (request.method !== "POST") throw new Error("methodNotAllowed");
      const baseUrl = assertLocalRuntime(config);
      const sessionId = await parseArchiveBody(request);
      const token = bearerToken(request);
      const ownerId = await validateLocalUser(
        fetcher,
        baseUrl,
        config.anonKey,
        token,
      );
      const rows = await archiveOwnSession(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        ownerId,
        sessionId,
      );
      const session = sanitizeArchiveResult(rows, sessionId);
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
