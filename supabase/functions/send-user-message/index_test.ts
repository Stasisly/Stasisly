import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import { parseSendMessageBody, sanitizeRpcResult } from "./contract.ts";
import {
  assertLocalRuntime,
  createHandler,
  type RuntimeConfig,
} from "./index.ts";
import { safeLog } from "./safe_log.ts";

const OWNER_ID = "5c100000-0000-4000-8000-000000000001";
const SESSION_ID = "5c400000-0000-4000-8000-000000000001";
const MESSAGE_ID = "5c500000-0000-4000-8000-000000000001";
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
  body: unknown = { sessionId: SESSION_ID, content: "  hello  " },
  token = "valid-local-jwt",
): Request {
  return new Request(
    "http://127.0.0.1:54321/functions/v1/send-user-message",
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

function rpcRow(overrides: Record<string, unknown> = {}) {
  return {
    message_id: MESSAGE_ID,
    session_id: SESSION_ID,
    role: "user",
    content: "hello",
    created_at: "2026-06-20T10:00:00Z",
    session_message_count: 1,
    session_last_message_at: "2026-06-20T10:00:00Z",
    ...overrides,
  };
}

function statefulFetcher() {
  const calls: Array<{ path: string; method: string; body?: unknown }> = [];
  const fetcher = (async (
    input: string | URL | Request,
    init?: RequestInit,
  ) => {
    const url = new URL(input instanceof Request ? input.url : input);
    const method = init?.method ?? "GET";
    const body = init?.body ? JSON.parse(String(init.body)) : undefined;
    calls.push({ path: url.pathname, method, body });
    if (url.pathname === "/auth/v1/user") {
      return Response.json({ id: OWNER_ID });
    }
    if (
      url.pathname === "/rest/v1/rpc/send_user_message_core" &&
      method === "POST"
    ) {
      return Response.json([rpcRow({
        session_id: body.p_session_id,
        content: String(body.p_content).trim(),
      })]);
    }
    return new Response(null, { status: 404 });
  }) as typeof fetch;
  return { fetcher, calls };
}

Deno.test("body accepts only sessionId and content", async () => {
  assertEquals(await parseSendMessageBody(request()), {
    sessionId: SESSION_ID,
    content: "hello",
  });
  for (
    const field of [
      "role",
      "userId",
      "user_id",
      "owner",
      "ownerId",
      "specialistId",
      "specialist_id",
      "internalSpecialistId",
      "created_at",
      "createdAt",
      "message_count",
      "messageCount",
      "last_message_at",
      "lastMessageAt",
      "attachments",
      "assistant",
      "system",
      "tool",
      "metadata",
      "extra",
    ]
  ) {
    await assertRejects(
      async () =>
        await parseSendMessageBody(
          request({ sessionId: SESSION_ID, content: "ok", [field]: "x" }),
        ),
      Error,
      "invalidRequest",
    );
  }
  await assertRejects(
    async () => await parseSendMessageBody(request({})),
    Error,
    "invalidRequest",
  );
});

Deno.test("content validation trims and fails closed", async () => {
  assertEquals(
    (await parseSendMessageBody(request({
      sessionId: SESSION_ID,
      content: ` ${"x".repeat(4000)} `,
    }))).content.length,
    4000,
  );
  for (const content of [null, "", "     "]) {
    await assertRejects(
      async () =>
        await parseSendMessageBody(request({ sessionId: SESSION_ID, content })),
      Error,
      "contentInvalid",
    );
  }
  await assertRejects(
    async () =>
      await parseSendMessageBody(
        request({ sessionId: SESSION_ID, content: "x".repeat(4001) }),
      ),
    Error,
    "contentTooLong",
  );
});

Deno.test("RPC response is sanitized and public", () => {
  const payload = sanitizeRpcResult([rpcRow()]);
  assertEquals(Object.keys(payload).sort(), ["message", "session"]);
  assertEquals(Object.keys(payload.message).sort(), [
    "content",
    "createdAt",
    "messageId",
    "role",
    "sessionId",
  ]);
  assertEquals(Object.keys(payload.session).sort(), [
    "lastMessageAt",
    "messageCount",
    "sessionId",
  ]);
  const serialized = JSON.stringify(payload);
  for (
    const forbidden of [
      "user_id",
      "userId",
      "specialist_id",
      "specialistId",
      "prompt_template",
      "service_role",
      "JWT",
      "attachments",
      "metadata",
    ]
  ) {
    assertEquals(serialized.includes(forbidden), false);
  }
});

Deno.test("handler validates JWT, calls only RPC, and performs no direct writes", async () => {
  const { fetcher, calls } = statefulFetcher();
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher,
    logWriter: () => {},
  });
  const response = await handler(request());
  const body = await response.json();
  assertEquals(response.status, 201);
  assertEquals(body.message.role, "user");
  assertEquals(body.message.content, "hello");
  assertEquals(calls.map((call) => call.path), [
    "/auth/v1/user",
    "/rest/v1/rpc/send_user_message_core",
  ]);
  assertEquals(
    calls.some((call) =>
      call.path === "/rest/v1/messages" ||
      (call.path === "/rest/v1/chat_sessions" &&
        ["POST", "PATCH", "PUT", "DELETE"].includes(call.method))
    ),
    false,
  );
  assertEquals(calls[1].body, {
    p_session_id: SESSION_ID,
    p_owner_user_id: OWNER_ID,
    p_content: "hello",
  });
});

Deno.test("missing and invalid JWT fail before RPC", async () => {
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

Deno.test("RPC errors map to public errors without leaking ownership", async () => {
  const cases = [
    ["session_not_found", 404, "sessionNotFound"],
    ["session_archived", 409, "sessionArchived"],
    ["content_invalid", 400, "contentInvalid"],
    ["content_too_long", 400, "contentTooLong"],
    ["write_unconfirmed", 409, "writeUnconfirmed"],
  ] as const;
  for (const [message, status, code] of cases) {
    const handler = createHandler(LOCAL_CONFIG, {
      fetcher: (async (input) => {
        const url = new URL(input instanceof Request ? input.url : input);
        if (url.pathname === "/auth/v1/user") {
          return Response.json({ id: OWNER_ID });
        }
        if (url.pathname === "/rest/v1/rpc/send_user_message_core") {
          return Response.json({ message }, { status: 400 });
        }
        return new Response(null, { status: 404 });
      }) as typeof fetch,
      requestId: () => "request-test",
      logWriter: () => {},
    });
    const response = await handler(request());
    const body = await response.json();
    assertEquals(response.status, status);
    assertEquals(body.error.code, code);
    assertEquals(JSON.stringify(body).includes("owner"), false);
    assertEquals(JSON.stringify(body).includes("exists"), false);
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
    operation: "sendUserMessage",
    result: "error",
    latency: 1,
    contract_version: "1",
    request_id: "opaque",
    error_code: "sessionNotFound",
  }, (value) => serialized = value);
  for (
    const forbidden of [
      "user_id",
      "specialist_id",
      "JWT",
      "service_role",
      SESSION_ID,
    ]
  ) {
    assertEquals(serialized.includes(forbidden), false);
  }
});
