import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import { parseArchiveBody, sanitizeArchiveResult } from "./contract.ts";
import {
  assertLocalRuntime,
  createHandler,
  type RuntimeConfig,
} from "./index.ts";
import { safeLog } from "./safe_log.ts";

const OWNER_A = "41000000-0000-4000-8000-000000000001";
const OWNER_B = "41000000-0000-4000-8000-000000000002";
const SESSION_ID = "44000000-0000-4000-8000-000000000001";
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
  body: unknown = { sessionId: SESSION_ID },
  token = "valid-local-jwt",
): Request {
  return new Request(
    "http://127.0.0.1:54321/functions/v1/archive-own-chat-session",
    {
      method: "POST",
      headers: {
        authorization: `Bearer ${token}`,
        "content-type": "application/json",
      },
      body: JSON.stringify(body),
    },
  );
}

Deno.test("body accepts only sessionId", async () => {
  assertEquals(await parseArchiveBody(request()), SESSION_ID);
  for (
    const field of [
      "user_id",
      "userId",
      "specialist_id",
      "specialistId",
      "internalSpecialistId",
      "status",
      "newStatus",
      "message_count",
      "messageCount",
      "started_at",
      "startedAt",
      "last_message_at",
      "lastMessageAt",
      "roles",
      "permissions",
      "extra",
    ]
  ) {
    await assertRejects(
      async () =>
        await parseArchiveBody(
          request({ sessionId: SESSION_ID, [field]: "x" }),
        ),
      Error,
      "invalidRequest",
    );
  }
  await assertRejects(
    async () => await parseArchiveBody(request({})),
    Error,
    "invalidRequest",
  );
});

Deno.test("archive result is minimal and exact", async () => {
  assertEquals(
    sanitizeArchiveResult([{
      id: SESSION_ID,
      status: "archived",
    }], SESSION_ID),
    { sessionId: SESSION_ID, status: "archived" },
  );
  for (
    const rows of [
      [],
      [{ id: SESSION_ID, status: "active" }],
      [{ id: OWNER_A, status: "archived" }],
      [{ id: SESSION_ID, status: "archived", last_message_at: "x" }],
      [
        { id: SESSION_ID, status: "archived" },
        { id: SESSION_ID, status: "archived" },
      ],
    ]
  ) {
    await assertRejects(
      async () => sanitizeArchiveResult(rows, SESSION_ID),
      Error,
    );
  }
});

Deno.test("handler performs one narrow PATCH and returns minimal response", async () => {
  let patchUrl = "";
  let patchBody = "";
  const paths: string[] = [];
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request, init?: RequestInit) => {
      const url = new URL(input instanceof Request ? input.url : input);
      paths.push(url.pathname);
      if (url.pathname === "/auth/v1/user") {
        return Response.json({ id: OWNER_A });
      }
      if (url.pathname === "/rest/v1/chat_sessions") {
        patchUrl = url.toString();
        patchBody = String(init?.body);
        assertEquals(init?.method, "PATCH");
        return Response.json([{ id: SESSION_ID, status: "archived" }]);
      }
      return new Response(null, { status: 404 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(request());
  const body = await response.json();
  assertEquals(response.status, 200);
  assertEquals(body, {
    session: { sessionId: SESSION_ID, status: "archived" },
  });
  assertEquals(JSON.parse(patchBody), { status: "archived" });
  const url = new URL(patchUrl);
  assertEquals(url.searchParams.get("id"), `eq.${SESSION_ID}`);
  assertEquals(url.searchParams.get("user_id"), `eq.${OWNER_A}`);
  assertEquals(url.searchParams.get("status"), "eq.active");
  assertEquals(url.searchParams.get("select"), "id,status");
  assertEquals(paths, ["/auth/v1/user", "/rest/v1/chat_sessions"]);
});

Deno.test("missing, foreign and archived all produce indistinguishable response", async () => {
  for (const tokenOwner of [OWNER_A, OWNER_B]) {
    const handler = createHandler(LOCAL_CONFIG, {
      fetcher: (async (input: string | URL | Request) => {
        const url = new URL(input instanceof Request ? input.url : input);
        if (url.pathname === "/auth/v1/user") {
          return Response.json({ id: tokenOwner });
        }
        return Response.json([]);
      }) as typeof fetch,
      requestId: () => "same-request-id",
      logWriter: () => {},
    });
    const response = await handler(request());
    assertEquals(response.status, 404);
    assertEquals(await response.json(), {
      error: { code: "sessionNotFound", requestId: "same-request-id" },
    });
  }
});

Deno.test("JWT, runtime and logs fail closed", async () => {
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async () => new Response(null, { status: 401 })) as typeof fetch,
    logWriter: () => {},
  });
  const noJwt = request();
  noJwt.headers.delete("authorization");
  assertEquals((await handler(noJwt)).status, 401);
  assertEquals((await handler(request(undefined, "invalid"))).status, 401);
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
    operation: "archiveOwnChatSession",
    result: "success",
    latency: 1,
    contract_version: "1",
    request_id: "opaque",
  }, (value) => serialized = value);
  for (
    const forbidden of [
      "user_id",
      "specialist_id",
      "sessionId",
      "JWT",
      "service_role",
    ]
  ) {
    assertEquals(serialized.includes(forbidden), false);
  }
});
