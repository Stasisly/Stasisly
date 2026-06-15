import { parseAreaFilter, sanitizeCatalogRows } from "./contract.ts";
import {
  type CatalogErrorCode,
  errorCodeFrom,
  errorResponse,
} from "./errors.ts";
import { type LogWriter, safeLog } from "./safe_log.ts";

const OPERATION = "listSelectableSpecialists";
const INTERNAL_COLUMNS = [
  "id",
  "display_name",
  "product_area",
  "short_description",
  "is_published",
  "availability_status",
  "access_tier",
  "sort_order",
  "specialist_id",
].join(",");

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
    config.allowLocalOnly !== "true" ||
    !config.anonKey ||
    !config.serviceRoleKey
  ) {
    throw new Error("catalogBackendBlocked");
  }

  let url: URL;
  try {
    url = new URL(config.supabaseUrl);
  } catch {
    throw new Error("catalogBackendBlocked");
  }

  if (
    url.protocol !== "http:" ||
    !LOCAL_ENDPOINTS.has(url.host)
  ) {
    throw new Error("catalogBackendBlocked");
  }
  return url;
}

function bearerToken(request: Request): string {
  const authorization = request.headers.get("authorization") ?? "";
  const match = /^Bearer ([^\s]+)$/.exec(authorization);
  if (!match) throw new Error("catalogUnauthenticated");
  return match[1];
}

async function validateLocalUser(
  fetcher: typeof fetch,
  baseUrl: URL,
  anonKey: string,
  token: string,
): Promise<string> {
  const response = await fetcher(new URL("/auth/v1/user", baseUrl), {
    headers: {
      apikey: anonKey,
      authorization: `Bearer ${token}`,
    },
  });
  if (!response.ok) throw new Error("catalogUnauthenticated");

  const body = await response.json();
  if (
    typeof body !== "object" || body === null || Array.isArray(body) ||
    typeof (body as Record<string, unknown>).id !== "string"
  ) {
    throw new Error("catalogUnauthenticated");
  }
  return (body as Record<string, string>).id;
}

async function fetchCatalog(
  fetcher: typeof fetch,
  baseUrl: URL,
  serviceRoleKey: string,
  area: string | undefined,
): Promise<unknown> {
  const query = new URL("/rest/v1/specialist_catalog", baseUrl);
  query.searchParams.set("select", INTERNAL_COLUMNS);
  query.searchParams.set("is_published", "eq.true");
  if (area) query.searchParams.set("product_area", `eq.${area}`);
  query.searchParams.set("order", "sort_order.asc,display_name.asc,id.asc");
  query.searchParams.set("limit", "20");

  const response = await fetcher(query, {
    headers: {
      apikey: serviceRoleKey,
      authorization: `Bearer ${serviceRoleKey}`,
      accept: "application/json",
    },
  });
  if (!response.ok) throw new Error("catalogBackendBlocked");
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
    const startedAt = now();
    const id = requestId();
    let count = 0;
    let result: "success" | "error" = "error";

    try {
      if (request.method !== "GET") {
        throw new Error("catalogMethodNotAllowed");
      }
      const area = parseAreaFilter(new URL(request.url));
      const baseUrl = assertLocalRuntime(config);
      const token = bearerToken(request);
      await validateLocalUser(fetcher, baseUrl, config.anonKey, token);
      const rows = await fetchCatalog(
        fetcher,
        baseUrl,
        config.serviceRoleKey,
        area,
      );
      const items = sanitizeCatalogRows(rows);
      count = items.length;
      result = "success";
      return Response.json(
        { items },
        {
          status: 200,
          headers: {
            "cache-control": "no-store",
            "content-type": "application/json",
          },
        },
      );
    } catch (error) {
      return errorResponse(errorCodeFrom(error) as CatalogErrorCode, id);
    } finally {
      safeLog(
        {
          operation: OPERATION,
          result,
          latency: Math.max(0, now() - startedAt),
          count,
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
