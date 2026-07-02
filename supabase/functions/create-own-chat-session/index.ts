import {
  corsHeadersFor,
  preflightResponse,
  withCorsHeaders,
} from "../_shared/cors.ts";
import { assertAllowedRuntime } from "../_shared/runtime_guard.ts";
import {
  assertInternalSpecialistExists,
  parseRequestBody,
  resolveSpecialist,
  sanitizeCreatedSession,
} from "./contract.ts";
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

function bearerToken(request: Request): string {
  const match = /^Bearer ([^\s]+)$/.exec(
    request.headers.get("authorization") ?? "",
  );
  if (!match) throw new Error("unauthenticated");
  return match[1];
}

async function requestJson(
  fetcher: typeof fetch,
  input: URL,
  init: RequestInit,
  errorCode: CreateSessionErrorCode,
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
  ) {
    throw new Error("invalidSession");
  }
  return (body as Record<string, string>).id;
}

async function assertOwnerProfile(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  ownerId: string,
): Promise<void> {
  const url = new URL("/rest/v1/users", baseUrl);
  url.searchParams.set("select", "id");
  url.searchParams.set("id", `eq.${ownerId}`);
  const rows = await requestJson(
    fetcher,
    url,
    { headers: privilegedHeaders(serviceRoleKey) },
    "permissionDenied",
  );
  if (!Array.isArray(rows) || rows.length !== 1) {
    throw new Error("permissionDenied");
  }
}

async function fetchResolvedSpecialist(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  selectableId: string,
) {
  const url = new URL("/rest/v1/specialist_catalog", baseUrl);
  url.searchParams.set(
    "select",
    "id,specialist_id,display_name,product_area,is_published,availability_status,access_tier",
  );
  url.searchParams.set("id", `eq.${selectableId}`);
  const rows = await requestJson(
    fetcher,
    url,
    { headers: privilegedHeaders(serviceRoleKey) },
    "backendMisconfigured",
  );
  return resolveSpecialist(rows);
}

async function assertSpecialistExists(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  internalId: string,
): Promise<void> {
  const url = new URL("/rest/v1/specialists", baseUrl);
  url.searchParams.set("select", "id");
  url.searchParams.set("id", `eq.${internalId}`);
  const rows = await requestJson(
    fetcher,
    url,
    { headers: privilegedHeaders(serviceRoleKey) },
    "backendMisconfigured",
  );
  assertInternalSpecialistExists(rows);
}

async function createSession(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  ownerId: string,
  internalSpecialistId: string,
): Promise<unknown> {
  const url = new URL("/rest/v1/chat_sessions", baseUrl);
  url.searchParams.set(
    "select",
    "id,started_at,last_message_at,status,message_count",
  );
  return await requestJson(
    fetcher,
    url,
    {
      method: "POST",
      headers: {
        ...privilegedHeaders(serviceRoleKey),
        "content-type": "application/json",
        prefer: "return=representation",
      },
      body: JSON.stringify({
        user_id: ownerId,
        specialist_id: internalSpecialistId,
        status: "active",
        message_count: 0,
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
    const id = requestId();
    let result: "success" | "error" = "error";
    try {
      if (request.method !== "POST") throw new Error("methodNotAllowed");
      const baseUrl = assertLocalRuntime(config);
      const selectableId = await parseRequestBody(request);
      const token = bearerToken(request);
      const ownerId = await validateLocalUser(
        fetcher,
        baseUrl,
        config.anonKey,
        token,
      );
      await assertOwnerProfile(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        ownerId,
      );
      const specialist = await fetchResolvedSpecialist(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        selectableId,
      );
      await assertSpecialistExists(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        specialist.internalId,
      );
      const rows = await createSession(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        ownerId,
        specialist.internalId,
      );
      const session = sanitizeCreatedSession(rows, specialist);
      result = "success";
      return Response.json(
        { session },
        {
          status: 201,
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
