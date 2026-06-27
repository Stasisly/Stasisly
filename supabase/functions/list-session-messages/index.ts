import {
  assertOwnedSession,
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

const OPERATION = "listSessionMessages";
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
  ) {
    throw new Error("backendMisconfigured");
  }
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
  error: ListMessagesErrorCode,
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
  ) {
    throw new Error("invalidSession");
  }
  return (body as Record<string, string>).id;
}

function sessionUrl(baseUrl: URL, sessionId: string, ownerId: string): URL {
  const url = new URL("/rest/v1/chat_sessions", baseUrl);
  url.searchParams.set("select", "id,user_id,status");
  url.searchParams.set("id", `eq.${sessionId}`);
  url.searchParams.set("user_id", `eq.${ownerId}`);
  return url;
}

function messagesUrl(
  baseUrl: URL,
  sessionId: string,
  limit: number,
  cursor?: CursorValue,
): URL {
  const url = new URL("/rest/v1/messages", baseUrl);
  url.searchParams.set("select", "id,session_id,role,content,created_at");
  url.searchParams.set("session_id", `eq.${sessionId}`);
  if (cursor) {
    url.searchParams.set(
      "or",
      `(created_at.gt.${cursor.createdAt},and(created_at.eq.${cursor.createdAt},id.gt.${cursor.messageId}))`,
    );
  }
  url.searchParams.set("order", "created_at.asc,id.asc");
  url.searchParams.set("limit", String(limit + 1));
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
    let errorCode: ListMessagesErrorCode | undefined;
    try {
      if (request.method !== "GET") throw new Error("methodNotAllowed");
      const listRequest = parseListMessagesRequest(new URL(request.url));
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
        sessionUrl(baseUrl, listRequest.sessionId, ownerId),
        { headers: privilegedHeaders(config.serviceRoleKey) },
        "backendMisconfigured",
      );
      assertOwnedSession(sessionRows, ownerId, listRequest.sessionId);
      const messageRows = await requestJson(
        fetcher,
        messagesUrl(
          baseUrl,
          listRequest.sessionId,
          listRequest.limit,
          listRequest.cursor,
        ),
        { headers: privilegedHeaders(config.serviceRoleKey) },
        "backendMisconfigured",
      );
      const response = buildMessagesResponse(messageRows, listRequest.limit);
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
      errorCode = errorCodeFrom(error);
      return errorResponse(errorCode, id);
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
