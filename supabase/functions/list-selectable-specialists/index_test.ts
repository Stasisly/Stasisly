import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import { calculateAccessState } from "./access_state.ts";
import { parseAreaFilter, sanitizeCatalogRows } from "./contract.ts";
import {
  assertLocalRuntime,
  createHandler,
  type RuntimeConfig,
} from "./index.ts";
import { safeLog } from "./safe_log.ts";

const LOCAL_CONFIG: RuntimeConfig = {
  supabaseUrl: "http://127.0.0.1:54321",
  anonKey: "local-anon-placeholder",
  serviceRoleKey: "local-service-role-placeholder",
  allowLocalOnly: "true",
  runtimeMode: "local",
  allowDevelopmentRemote: "false",
  corsAllowedOrigins: "",
};

const INTERNAL_ROW = {
  id: "20000000-0000-4000-8000-000000000001",
  display_name: "Stasis",
  product_area: "stasis",
  short_description: "Fixture sanitizado.",
  is_published: true,
  availability_status: "available",
  access_tier: "free",
  sort_order: 10,
  specialist_id: "10000000-0000-4000-8000-000000000001",
};

function mockFetcher(rows: unknown = [INTERNAL_ROW]): typeof fetch {
  return (async (input: string | URL | Request) => {
    const url = new URL(input instanceof Request ? input.url : input);
    if (url.pathname === "/auth/v1/user") {
      return Response.json({ id: "30000000-0000-4000-8000-000000000001" });
    }
    if (url.pathname === "/rest/v1/specialist_catalog") {
      return Response.json(rows);
    }
    return new Response(null, { status: 404 });
  }) as typeof fetch;
}

function request(path = "", token = "valid-local-jwt"): Request {
  return new Request(
    `http://127.0.0.1:54321/functions/v1/list-selectable-specialists${path}`,
    { headers: { authorization: `Bearer ${token}` } },
  );
}

Deno.test("accessState implements the approved local rules", () => {
  assertEquals(calculateAccessState("available", "free"), "available");
  assertEquals(calculateAccessState("available", "pro"), "lockedPro");
  assertEquals(calculateAccessState("available", "vip"), "lockedPro");
  assertEquals(calculateAccessState("unavailable", "free"), "unavailable");
  assertEquals(calculateAccessState("unavailable", "pro"), "unavailable");
  assertEquals(calculateAccessState("unavailable", "vip"), "unavailable");
});

Deno.test("accessState fails closed on contradictory values", async () => {
  await assertRejects(
    async () => calculateAccessState("unknown", "free"),
    Error,
    "catalogContractViolation",
  );
  await assertRejects(
    async () => calculateAccessState("available", "unknown"),
    Error,
    "catalogContractViolation",
  );
  await assertRejects(
    async () => calculateAccessState("available", "premium"),
    Error,
    "catalogContractViolation",
  );
});

Deno.test("contract emits exactly the six public fields", () => {
  const [item] = sanitizeCatalogRows([INTERNAL_ROW]);
  assertEquals(Object.keys(item).sort(), [
    "accessState",
    "area",
    "displayName",
    "id",
    "isDemo",
    "shortDescription",
  ]);
  assertEquals(item.isDemo, false);
  assertEquals(JSON.stringify(item).includes("specialist_id"), false);
  assertEquals(JSON.stringify(item).includes("prompt_template"), false);
});

Deno.test("contract accepts empty catalog and rejects unexpected columns", async () => {
  assertEquals(sanitizeCatalogRows([]), []);
  await assertRejects(
    async () =>
      sanitizeCatalogRows([{ ...INTERNAL_ROW, prompt_template: "x" }]),
    Error,
    "catalogContractViolation",
  );
});

Deno.test("area filter is explicit and invalid values fail", async () => {
  assertEquals(
    parseAreaFilter(new URL("http://localhost/?area=wellness")),
    "wellness",
  );
  await assertRejects(
    async () => parseAreaFilter(new URL("http://localhost/?area=mental")),
    Error,
    "catalogInvalidArea",
  );
});

Deno.test("local runtime blocks missing configuration and remote hosts", async () => {
  assertEquals(assertLocalRuntime(LOCAL_CONFIG).hostname, "127.0.0.1");
  assertEquals(
    assertLocalRuntime({ ...LOCAL_CONFIG, supabaseUrl: "http://kong:8000" })
      .host,
    "kong:8000",
  );
  await assertRejects(
    async () => assertLocalRuntime({ ...LOCAL_CONFIG, serviceRoleKey: "" }),
    Error,
    "catalogBackendBlocked",
  );
  await assertRejects(
    async () =>
      assertLocalRuntime({
        ...LOCAL_CONFIG,
        supabaseUrl: "https://example.supabase.co",
      }),
    Error,
    "catalogBackendBlocked",
  );
});

Deno.test("handler rejects missing JWT before any data request", async () => {
  let calls = 0;
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async () => {
      calls++;
      return new Response(null, { status: 500 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(new Request(request().url));
  assertEquals(response.status, 401);
  assertEquals(calls, 0);
});

Deno.test("handler rejects invalid JWT and never queries catalog", async () => {
  const paths: string[] = [];
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request) => {
      const url = new URL(input instanceof Request ? input.url : input);
      paths.push(url.pathname);
      return new Response(null, { status: 401 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(request("", "invalid"));
  assertEquals(response.status, 401);
  assertEquals(paths, ["/auth/v1/user"]);
});

Deno.test("handler rejects client-provided authority", async () => {
  const paths: string[] = [];
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request) => {
      const url = new URL(input instanceof Request ? input.url : input);
      paths.push(`${url.pathname}?${url.searchParams}`);
      if (url.pathname === "/auth/v1/user") {
        return Response.json({ id: "validated-user" });
      }
      return Response.json([INTERNAL_ROW]);
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(
    request("?area=stasis&user_id=attacker&role=admin&accessState=available"),
  );
  const body = await response.json();
  assertEquals(response.status, 400);
  assertEquals(body.error.code, "catalogInvalidRequest");
  assertEquals(paths, []);
});

Deno.test("handler rejects authority-bearing headers before backend access", async () => {
  let calls = 0;
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (() => {
      calls += 1;
      return Promise.reject(new Error("must not call backend"));
    }) as typeof fetch,
  });
  for (
    const header of [
      "x-owner-id",
      "x-role",
      "x-stasisly-surface",
      "x-stasisly-environment",
      "x-entitlement",
    ]
  ) {
    const input = request();
    input.headers.set(header, "attacker");
    const response = await handler(input);
    assertEquals(response.status, 400);
    assertEquals((await response.json()).error.code, "catalogInvalidRequest");
  }
  assertEquals(calls, 0);
});

Deno.test("handler applies Product selection guards, area and stable order", async () => {
  let catalogUrl = "";
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request) => {
      const url = new URL(input instanceof Request ? input.url : input);
      if (url.pathname === "/auth/v1/user") {
        return Response.json({ id: "validated-user" });
      }
      catalogUrl = url.toString();
      return Response.json([]);
    }) as typeof fetch,
    logWriter: () => {},
  });
  assertEquals((await handler(request("?area=wellness"))).status, 200);
  const url = new URL(catalogUrl);
  assertEquals(url.searchParams.get("is_published"), "eq.true");
  assertEquals(url.searchParams.get("publication_status"), "eq.published");
  assertEquals(url.searchParams.get("availability_status"), "eq.available");
  assertEquals(url.searchParams.get("supported_surfaces"), "eq.{product}");
  assertEquals(url.searchParams.get("is_conversable"), "eq.true");
  assertEquals(url.searchParams.get("product_area"), "eq.wellness");
  assertEquals(
    url.searchParams.get("order"),
    "sort_order.asc,display_name.asc,id.asc",
  );
  assertEquals(url.searchParams.get("limit"), "20");
});

Deno.test("safe logs contain only allowlisted values", () => {
  let serialized = "";
  safeLog(
    {
      operation: "listSelectableSpecialists",
      result: "success",
      latency: 2,
      count: 1,
      contract_version: "1",
      request_id: "opaque",
    },
    (value) => serialized = value,
  );
  assertEquals(serialized.includes("service_role"), false);
  assertEquals(serialized.includes("prompt_template"), false);
  assertEquals(serialized.includes("JWT"), false);
  assertEquals(Object.keys(JSON.parse(serialized)).sort(), [
    "contract_version",
    "count",
    "latency",
    "operation",
    "request_id",
    "result",
  ]);
});
