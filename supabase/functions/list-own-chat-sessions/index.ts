import {
  buildListResponse,
  internalSpecialistIds,
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
const LOCAL_ENDPOINTS = new Set([
  "127.0.0.1:54321",
  "localhost:54321",
  "host.docker.internal:54321",
  "kong:8000",
]);

export interface RuntimeConfig {
  supabaseUrl: string;
  anonKey: string;
  serviceRoleKey: string;
  allowLocalOnly: string;
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
  };
}

export function assertLocalRuntime(config: RuntimeConfig): URL {
  if (
    config.allowLocalOnly !== "true" || !config.anonKey ||
    !config.serviceRoleKey
  ) throw new Error("backendMisconfigured");
  let url: URL;
  try {
    url = new URL(config.supabaseUrl);
  } catch {
    throw new Error("backendMisconfigured");
  }
  if (url.protocol !== "http:" || !LOCAL_ENDPOINTS.has(url.host)) {
    throw new Error("backendMisconfigured");
  }
  return url;
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

function sessionsUrl(
  baseUrl: URL,
  ownerId: string,
  request: ListRequest,
): URL {
  const url = new URL("/rest/v1/chat_sessions", baseUrl);
  url.searchParams.set(
    "select",
    "id,user_id,specialist_id,started_at,last_message_at,status,message_count",
  );
  url.searchParams.set("user_id", `eq.${ownerId}`);
  if (request.status !== "all") {
    url.searchParams.set("status", `eq.${request.status}`);
  }
  if (request.cursor) {
    const timestamp = request.cursor.lastMessageAt;
    const id = request.cursor.sessionId;
    url.searchParams.set(
      "or",
      `(last_message_at.lt.${timestamp},and(last_message_at.eq.${timestamp},id.lt.${id}))`,
    );
  }
  url.searchParams.set("order", "last_message_at.desc,id.desc");
  url.searchParams.set("limit", String(request.limit + 1));
  return url;
}

function catalogUrl(baseUrl: URL, specialistIds: string[]): URL {
  const url = new URL("/rest/v1/specialist_catalog", baseUrl);
  url.searchParams.set(
    "select",
    "id,specialist_id,display_name,product_area,is_published",
  );
  url.searchParams.set("specialist_id", `in.(${specialistIds.join(",")})`);
  url.searchParams.set("is_published", "eq.true");
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
    const startedAt = now();
    const id = requestId();
    let count = 0;
    let result: "success" | "error" = "error";
    try {
      if (request.method !== "GET") throw new Error("methodNotAllowed");
      const listRequest = parseListRequest(new URL(request.url));
      const baseUrl = assertLocalRuntime(config);
      const token = bearerToken(request);
      const ownerId = await validateLocalUser(
        fetcher,
        baseUrl,
        config.anonKey,
        token,
      );
      const sessionRows = await requestJson(
        fetcher,
        sessionsUrl(baseUrl, ownerId, listRequest),
        { headers: privilegedHeaders(config.serviceRoleKey) },
        "backendMisconfigured",
      );
      const specialistIds = internalSpecialistIds(sessionRows);
      const catalogRows = specialistIds.length === 0 ? [] : await requestJson(
        fetcher,
        catalogUrl(baseUrl, specialistIds),
        { headers: privilegedHeaders(config.serviceRoleKey) },
        "backendMisconfigured",
      );
      const response = buildListResponse(
        sessionRows,
        catalogRows,
        ownerId,
        listRequest.limit,
      );
      count = response.items.length;
      result = "success";
      return Response.json(response, {
        status: 200,
        headers: {
          "cache-control": "no-store",
          "content-type": "application/json",
        },
      });
    } catch (error) {
      return errorResponse(errorCodeFrom(error), id);
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
