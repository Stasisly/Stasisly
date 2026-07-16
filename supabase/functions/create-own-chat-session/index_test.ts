import {
  assertEquals,
  assertNotEquals,
  assertRejects,
} from "jsr:@std/assert@1";
import { parseRequestBody, sanitizeCreatedSession } from "./contract.ts";
import {
  assertLocalRuntime,
  createHandler,
  type RuntimeConfig,
} from "./index.ts";
import { safeLog } from "./safe_log.ts";

const OWNER_ID = "41000000-0000-4000-8000-000000000001";
const SELECTABLE_ID = "43000000-0000-4000-8000-000000000001";
const INTERNAL_ID = "42000000-0000-4000-8000-000000000001";
const LOCAL_CONFIG: RuntimeConfig = {
  supabaseUrl: "http://127.0.0.1:54321",
  anonKey: "local-anon-placeholder",
  serviceRoleKey: "local-service-role-placeholder",
  allowLocalOnly: "true",
  runtimeMode: "local",
  allowDevelopmentRemote: "false",
  corsAllowedOrigins: "",
};
function request(
  body: unknown = { selectableSpecialistId: SELECTABLE_ID },
  token = "valid-local-jwt",
  idempotencyKey = "create_attempt_00000001",
): Request {
  return new Request(
    "http://127.0.0.1:54321/functions/v1/create-own-chat-session",
    {
      method: "POST",
      headers: {
        authorization: `Bearer ${token}`,
        "content-type": "application/json",
        "Idempotency-Key": idempotencyKey,
      },
      body: JSON.stringify(body),
    },
  );
}

function statefulFetcher() {
  const inserted: Record<string, unknown>[] = [];
  const fetcher = (async (
    input: string | URL | Request,
    init?: RequestInit,
  ) => {
    const url = new URL(input instanceof Request ? input.url : input);
    if (url.pathname === "/auth/v1/user") {
      return Response.json({ id: OWNER_ID });
    }
    if (
      url.pathname === "/rest/v1/rpc/create_own_chat_session_core" &&
      init?.method === "POST"
    ) {
      const body = JSON.parse(String(init.body));
      inserted.push(body);
      const sequence = inserted.length.toString().padStart(12, "0");
      return Response.json([{
        session_id: `44000000-0000-4000-8000-${sequence}`,
        started_at: "2026-06-14T10:00:00Z",
        last_message_at: "2026-06-14T10:00:00Z",
        status: "active",
        message_count: 0,
        selectable_specialist_id: SELECTABLE_ID,
        specialist_display_name: "Fixture local",
        product_area: "wellness",
        idempotent_replay: false,
      }], { status: 201 });
    }
    return new Response(null, { status: 404 });
  }) as typeof fetch;
  return { fetcher, inserted };
}

Deno.test("body accepts only selectableSpecialistId", async () => {
  assertEquals(await parseRequestBody(request()), SELECTABLE_ID);
  for (
    const field of [
      "user_id",
      "userId",
      "specialist_id",
      "specialistId",
      "internalSpecialistId",
      "catalogId",
      "agentId",
      "ownerUserId",
      "sessionId",
      "role",
      "surface",
      "status",
      "message_count",
      "messageCount",
      "started_at",
      "startedAt",
      "last_message_at",
      "lastMessageAt",
      "accessState",
      "access_tier",
      "availability_status",
      "publication_status",
      "is_conversable",
      "prompt",
      "prompt_template",
      "roles",
      "permissions",
      "extra",
    ]
  ) {
    await assertRejects(
      async () =>
        await parseRequestBody(
          request({ selectableSpecialistId: SELECTABLE_ID, [field]: "x" }),
        ),
      Error,
      "invalidRequest",
    );
  }
  await assertRejects(
    async () => await parseRequestBody(request({})),
    Error,
    "invalidRequest",
  );
  await assertRejects(
    async () => await parseRequestBody(request([])),
    Error,
    "invalidRequest",
  );
  for (const invalidId of ["", 42, null]) {
    await assertRejects(
      async () =>
        await parseRequestBody(
          request({ selectableSpecialistId: invalidId }),
        ),
      Error,
      "invalidRequest",
    );
  }
  await assertRejects(
    async () =>
      await parseRequestBody(
        new Request(request().url, {
          method: "POST",
          headers: { "content-type": "application/json" },
          body: "not-json",
        }),
      ),
    Error,
    "invalidRequest",
  );
});

Deno.test("handler delegates eligibility and insert to one transactional RPC", async () => {
  const { fetcher, inserted } = statefulFetcher();
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher,
    logWriter: () => {},
  });
  assertEquals((await handler(request())).status, 201);
  assertEquals(inserted.length, 1);
  assertEquals(inserted[0], {
    p_owner_user_id: OWNER_ID,
    p_selectable_specialist_id: SELECTABLE_ID,
    p_idempotency_key: "create_attempt_00000001",
  });
});

Deno.test("public response excludes user_id and specialist_id", () => {
  const sanitized = sanitizeCreatedSession([{
    session_id: "44000000-0000-4000-8000-000000000001",
    started_at: "2026-06-14T10:00:00Z",
    last_message_at: "2026-06-14T10:00:00Z",
    status: "active",
    message_count: 0,
    selectable_specialist_id: SELECTABLE_ID,
    specialist_display_name: "Fixture local",
    product_area: "wellness",
    idempotent_replay: false,
  }]);
  const session = sanitized.session;
  const serialized = JSON.stringify(session);
  assertEquals(serialized.includes("user_id"), false);
  assertEquals(serialized.includes("specialist_id"), false);
  assertEquals(serialized.includes(INTERNAL_ID), false);
  assertEquals(Object.keys(session).sort(), [
    "lastMessageAt",
    "messageCount",
    "selectableSpecialist",
    "sessionId",
    "startedAt",
    "status",
  ]);
});

Deno.test("two valid calls create two distinct sessions and no message request", async () => {
  const { fetcher, inserted } = statefulFetcher();
  const paths: string[] = [];
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input, init) => {
      const url = new URL(input instanceof Request ? input.url : input);
      paths.push(url.pathname);
      return await fetcher(input, init);
    }) as typeof fetch,
    logWriter: () => {},
  });
  const first = await handler(request());
  const second = await handler(
    request(undefined, undefined, "create_attempt_00000002"),
  );
  const firstBody = await first.json();
  const secondBody = await second.json();
  assertEquals(first.status, 201);
  assertEquals(second.status, 201);
  assertNotEquals(firstBody.session.sessionId, secondBody.session.sessionId);
  assertEquals(inserted.length, 2);
  assertEquals(inserted[0].p_owner_user_id, OWNER_ID);
  assertEquals(inserted[0].p_selectable_specialist_id, SELECTABLE_ID);
  assertEquals(paths.includes("/rest/v1/messages"), false);
  assertEquals(JSON.stringify(firstBody).includes("user_id"), false);
  assertEquals(JSON.stringify(firstBody).includes("specialist_id"), false);
});

Deno.test("handler rejects missing and invalid JWT", async () => {
  let calls = 0;
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async () => {
      calls++;
      return new Response(null, { status: 401 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const withoutJwt = request();
  withoutJwt.headers.delete("authorization");
  assertEquals((await handler(withoutJwt)).status, 401);
  assertEquals(calls, 0);
  assertEquals((await handler(request(undefined, "invalid"))).status, 401);
  assertEquals(calls, 1);
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

Deno.test("preflight returns before auth and backend access", async () => {
  let calls = 0;
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async () => {
      calls++;
      return new Response(null, { status: 500 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(
    new Request(
      "http://127.0.0.1:54321/functions/v1/create-own-chat-session",
      {
        method: "OPTIONS",
        headers: { origin: "http://localhost:3000" },
      },
    ),
  );
  assertEquals(response.status, 204);
  assertEquals(calls, 0);
  assertEquals(
    response.headers.get("access-control-allow-origin"),
    "http://localhost:3000",
  );
});

Deno.test("create requires idempotency metadata without backend access", async () => {
  let calls = 0;
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async () => {
      calls++;
      return new Response(null, { status: 500 });
    }) as typeof fetch,
    requestId: () => "request-test",
    logWriter: () => {},
  });
  const missing = request();
  missing.headers.delete("Idempotency-Key");
  const missingResponse = await handler(missing);
  assertEquals(missingResponse.status, 400);
  assertEquals(
    (await missingResponse.json()).error.code,
    "missingIdempotencyKey",
  );
  const invalidResponse = await handler(
    request(undefined, undefined, "invalid key"),
  );
  assertEquals(invalidResponse.status, 400);
  assertEquals(
    (await invalidResponse.json()).error.code,
    "invalidIdempotencyKey",
  );
  assertEquals(calls, 0);
});

Deno.test("create replay is successful without changing the public DTO", async () => {
  const { fetcher } = statefulFetcher();
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input, init) => {
      const response = await fetcher(input, init);
      const url = new URL(input instanceof Request ? input.url : input);
      if (url.pathname !== "/rest/v1/rpc/create_own_chat_session_core") {
        return response;
      }
      const rows = await response.json();
      rows[0].idempotent_replay = true;
      return Response.json(rows);
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(request());
  const body = await response.json();
  assertEquals(response.status, 200);
  assertEquals(Object.keys(body), ["session"]);
  assertEquals(JSON.stringify(body).includes("idempotent"), false);
});

Deno.test("create maps idempotency and transaction failures opaquely", async () => {
  const cases = [
    ["idempotency_conflict", 409, "idempotencyConflict"],
    ["operation_in_progress", 409, "operationInProgress"],
    ["transaction_failed", 503, "transactionFailed"],
  ] as const;
  for (const [message, status, code] of cases) {
    const handler = createHandler(LOCAL_CONFIG, {
      fetcher: (async (input) => {
        const url = new URL(input instanceof Request ? input.url : input);
        if (url.pathname === "/auth/v1/user") {
          return Response.json({ id: OWNER_ID });
        }
        if (url.pathname === "/rest/v1/rpc/create_own_chat_session_core") {
          return Response.json({ message }, { status: 400 });
        }
        return new Response(null, { status: 404 });
      }) as typeof fetch,
      logWriter: () => {},
    });
    const response = await handler(request());
    assertEquals(response.status, status);
    assertEquals((await response.json()).error.code, code);
  }
});

Deno.test("local runtime and logs fail closed", async () => {
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
    operation: "createOwnChatSession",
    result: "success",
    latency: 1,
    contract_version: "1",
    request_id: "opaque",
  }, (value) => serialized = value);
  for (const forbidden of ["user_id", "specialist_id", "JWT", "service_role"]) {
    assertEquals(serialized.includes(forbidden), false);
  }
});
