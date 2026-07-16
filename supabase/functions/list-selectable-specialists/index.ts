import {
  corsHeadersFor,
  preflightResponse,
  withCorsHeaders,
} from "../_shared/cors.ts";
import { BACKEND_OPERATIONS } from "../_shared/authorization/backend_operation_definition.ts";
import { prepareBackendAuthorization } from "../_shared/authorization/backend_request_authorization.ts";
import { assertAllowedRuntime } from "../_shared/runtime_guard.ts";
import { parseAreaFilter, sanitizeCatalogRows } from "./contract.ts";
import {
  type CatalogErrorCode,
  errorCodeFrom,
  errorResponse,
} from "./errors.ts";
import { type LogWriter, safeLog } from "./safe_log.ts";

const OPERATION = "listSelectableSpecialists";
const METHODS = ["GET", "OPTIONS"];
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
  try {
    return assertAllowedRuntime(config);
  } catch {
    throw new Error("catalogBackendBlocked");
  }
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
  query.searchParams.set("publication_status", "eq.published");
  query.searchParams.set("availability_status", "eq.available");
  query.searchParams.set("supported_surfaces", "eq.{product}");
  query.searchParams.set("is_conversable", "eq.true");
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
    if (request.method === "OPTIONS") {
      return preflightResponse(request, config, METHODS);
    }
    const startedAt = now();
    let id = requestId();
    let count = 0;
    let result: "success" | "error" = "error";

    try {
      if (request.method !== "GET") {
        throw new Error("catalogMethodNotAllowed");
      }
      const area = parseAreaFilter(new URL(request.url));
      const authorization = await prepareBackendAuthorization({
        request,
        fetcher,
        config,
        operation: BACKEND_OPERATIONS.listSelectableSpecialists,
        generateCorrelationId: () => id,
      });
      id = authorization.context.correlationId;
      const rows = await fetchCatalog(
        fetcher,
        authorization.baseUrl,
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
            ...corsHeadersFor(request, config, METHODS),
            "cache-control": "no-store",
            "content-type": "application/json",
          },
        },
      );
    } catch (error) {
      return withCorsHeaders(
        errorResponse(errorCodeFrom(error) as CatalogErrorCode, id),
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
