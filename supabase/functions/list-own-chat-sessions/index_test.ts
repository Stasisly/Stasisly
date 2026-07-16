import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import {
  buildListResponse,
  decodeCursor,
  encodeCursor,
  parseListRequest,
} from "./contract.ts";
import {
  assertLocalRuntime,
  createHandler,
  type RuntimeConfig,
} from "./index.ts";
import { safeLog } from "./safe_log.ts";

const OWNER_A = "41000000-0000-4000-8000-000000000001";
const OWNER_B = "41000000-0000-4000-8000-000000000002";
const SPECIALIST = "42000000-0000-4000-8000-000000000001";
const SELECTABLE = "43000000-0000-4000-8000-000000000001";
const LOCAL_CONFIG: RuntimeConfig = {
  supabaseUrl: "http://127.0.0.1:54321",
  anonKey: "local-anon-placeholder",
  serviceRoleKey: "local-service-role-placeholder",
  allowLocalOnly: "true",
  runtimeMode: "local",
  allowDevelopmentRemote: "false",
  corsAllowedOrigins: "",
};
const CATALOG = [{
  id: SELECTABLE,
  specialist_id: SPECIALIST,
  display_name: "Fixture local",
  product_area: "wellness",
  is_published: true,
}];

function row(
  id: string,
  lastMessageAt: string,
  owner = OWNER_A,
  specialist = SPECIALIST,
  status = "active",
) {
  return {
    id,
    user_id: owner,
    specialist_id: specialist,
    started_at: "2026-06-14T10:00:00Z",
    last_message_at: lastMessageAt,
    status,
    message_count: 0,
  };
}

function request(query = "", token = "valid-local-jwt"): Request {
  return new Request(
    `http://127.0.0.1:54321/functions/v1/list-own-chat-sessions${query}`,
    { headers: { authorization: `Bearer ${token}` } },
  );
}

Deno.test("query params, defaults and strict cursor are validated", async () => {
  assertEquals(parseListRequest(new URL(request().url)), {
    status: "active",
    limit: 20,
    cursor: undefined,
  });
  assertEquals(
    parseListRequest(new URL(request("?status=all&limit=50").url)).status,
    "all",
  );
  const cursor = {
    v: 1 as const,
    lastMessageAt: "2026-06-14T10:00:00Z",
    sessionId: "44000000-0000-4000-8000-000000000001",
  };
  assertEquals(decodeCursor(encodeCursor(cursor)), cursor);
  for (
    const query of [
      "?user_id=x",
      "?specialist_id=x",
      "?unknown=x",
      "?status=bad",
      "?limit=0",
      "?limit=51",
      "?limit=01",
      "?cursor=broken",
      "?status=active&status=all",
    ]
  ) {
    await assertRejects(
      async () => parseListRequest(new URL(request(query).url)),
      Error,
    );
  }
});

Deno.test("projection excludes user_id, specialist_id and internal ID", () => {
  const response = buildListResponse(
    [
      row("44000000-0000-4000-8000-000000000001", "2026-06-14T12:00:00Z"),
    ],
    CATALOG,
    OWNER_A,
    20,
  );
  const serialized = JSON.stringify(response);
  assertEquals(serialized.includes("user_id"), false);
  assertEquals(serialized.includes("specialist_id"), false);
  assertEquals(serialized.includes(SPECIALIST), false);
  assertEquals(Object.keys(response.items[0]).sort(), [
    "lastMessageAt",
    "messageCount",
    "selectableSpecialist",
    "sessionId",
    "startedAt",
    "status",
  ]);
});

Deno.test("broken or duplicate catalog aborts complete response", async () => {
  const sessions = [
    row("44000000-0000-4000-8000-000000000001", "2026-06-14T12:00:00Z"),
    row(
      "44000000-0000-4000-8000-000000000002",
      "2026-06-14T11:00:00Z",
      OWNER_A,
      "42000000-0000-4000-8000-000000000002",
    ),
  ];
  await assertRejects(
    async () => buildListResponse(sessions, CATALOG, OWNER_A, 20),
    Error,
    "contractViolation",
  );
  await assertRejects(
    async () =>
      buildListResponse([sessions[0]], [...CATALOG, ...CATALOG], OWNER_A, 20),
    Error,
    "contractViolation",
  );
  await assertRejects(
    async () =>
      buildListResponse(
        [sessions[0]],
        [{ ...CATALOG[0], is_published: false }],
        OWNER_A,
        20,
      ),
    Error,
    "contractViolation",
  );
});

Deno.test("cursor pages do not duplicate sessions", () => {
  const rows = [
    row("44000000-0000-4000-8000-000000000003", "2026-06-14T12:00:00Z"),
    row("44000000-0000-4000-8000-000000000002", "2026-06-14T12:00:00Z"),
    row("44000000-0000-4000-8000-000000000001", "2026-06-14T11:00:00Z"),
  ];
  const first = buildListResponse(rows, CATALOG, OWNER_A, 2);
  const cursor = decodeCursor(first.nextCursor!);
  assertEquals(cursor.sessionId, first.items[1].sessionId);
  const second = buildListResponse([rows[2]], CATALOG, OWNER_A, 2);
  const firstIds = new Set(first.items.map((item) => item.sessionId));
  assertEquals(
    second.items.some((item) => firstIds.has(item.sessionId)),
    false,
  );
  assertEquals(second.nextCursor, null);
});

Deno.test("handler derives owner and applies stable query", async () => {
  let sessionsQuery = "";
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request) => {
      const url = new URL(input instanceof Request ? input.url : input);
      if (url.pathname === "/auth/v1/user") {
        return Response.json({ id: OWNER_A });
      }
      if (url.pathname === "/rest/v1/chat_sessions") {
        sessionsQuery = url.toString();
        return Response.json([]);
      }
      return new Response(null, { status: 404 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(request("?status=all&limit=2"));
  assertEquals(response.status, 200);
  const url = new URL(sessionsQuery);
  assertEquals(url.searchParams.get("user_id"), `eq.${OWNER_A}`);
  assertEquals(url.searchParams.has("status"), false);
  assertEquals(url.searchParams.get("order"), "last_message_at.desc,id.desc");
  assertEquals(url.searchParams.get("limit"), "3");
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
    assertEquals((await response.json()).error.code, "invalidRequest");
  }
  assertEquals(calls, 0);
});

Deno.test("handler returns no partial items for broken catalog", async () => {
  const sessions = [
    row("44000000-0000-4000-8000-000000000001", "2026-06-14T12:00:00Z"),
    row(
      "44000000-0000-4000-8000-000000000002",
      "2026-06-14T11:00:00Z",
      OWNER_A,
      "42000000-0000-4000-8000-000000000002",
    ),
  ];
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request) => {
      const url = new URL(input instanceof Request ? input.url : input);
      if (url.pathname === "/auth/v1/user") {
        return Response.json({ id: OWNER_A });
      }
      if (url.pathname === "/rest/v1/chat_sessions") {
        return Response.json(sessions);
      }
      if (url.pathname === "/rest/v1/specialist_catalog") {
        return Response.json(CATALOG);
      }
      return new Response(null, { status: 404 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(request());
  const body = await response.json();
  assertEquals(response.status, 502);
  assertEquals(body.error.code, "contractViolation");
  assertEquals(Object.hasOwn(body, "items"), false);
});

Deno.test("JWT, ownership contract, runtime and logs fail closed", async () => {
  await assertRejects(
    async () =>
      buildListResponse(
        [
          row(
            "44000000-0000-4000-8000-000000000001",
            "2026-06-14T12:00:00Z",
            OWNER_B,
          ),
        ],
        CATALOG,
        OWNER_A,
        20,
      ),
    Error,
    "contractViolation",
  );
  assertEquals(assertLocalRuntime(LOCAL_CONFIG).hostname, "127.0.0.1");
  await assertRejects(
    async () =>
      assertLocalRuntime({
        ...LOCAL_CONFIG,
        supabaseUrl: "https://example.supabase.co",
      }),
    Error,
    "backendMisconfigured",
  );
  let serialized = "";
  safeLog({
    operation: "listOwnChatSessions",
    result: "success",
    latency: 1,
    count: 2,
    contract_version: "1",
    request_id: "opaque",
  }, (value) => serialized = value);
  for (const forbidden of ["user_id", "specialist_id", "JWT", "service_role"]) {
    assertEquals(serialized.includes(forbidden), false);
  }
});
