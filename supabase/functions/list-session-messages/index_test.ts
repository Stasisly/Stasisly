import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import {
  buildMessagesResponse,
  decodeCursor,
  encodeCursor,
  parseListMessagesRequest,
} from "./contract.ts";
import {
  assertLocalRuntime,
  createHandler,
  type RuntimeConfig,
} from "./index.ts";
import { safeLog } from "./safe_log.ts";

const OWNER_A = "5d100000-0000-4000-8000-000000000001";
const OWNER_B = "5d100000-0000-4000-8000-000000000002";
const SESSION_ACTIVE = "5d400000-0000-4000-8000-000000000001";
const SESSION_ARCHIVED = "5d400000-0000-4000-8000-000000000002";
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
  query = `?sessionId=${SESSION_ACTIVE}`,
  token = "valid-local-jwt",
): Request {
  return new Request(
    `http://127.0.0.1:54321/functions/v1/list-session-messages${query}`,
    { headers: { authorization: `Bearer ${token}` } },
  );
}

function messageRow(
  id: string,
  createdAt: string,
  role = "user",
  sessionId = SESSION_ACTIVE,
) {
  return {
    message_id: id,
    session_id: sessionId,
    role,
    content: `content-${id.slice(-1)}`,
    created_at: createdAt,
    author_type: role === "user" ? "user" : "unknown",
    provenance_type: role === "user" ? "userProvided" : "unknown",
    visibility_type: "productVisible",
    message_status: "accepted",
  };
}

Deno.test("query params, limits and strict cursor are validated", async () => {
  assertEquals(parseListMessagesRequest(new URL(request().url)), {
    sessionId: SESSION_ACTIVE,
    limit: 50,
    cursor: undefined,
  });
  assertEquals(
    parseListMessagesRequest(
      new URL(request(`?sessionId=${SESSION_ACTIVE}&limit=100`).url),
    )
      .limit,
    100,
  );
  const cursor = {
    v: 1 as const,
    createdAt: "2026-06-21T10:00:00Z",
    messageId: "5d500000-0000-4000-8000-000000000001",
  };
  assertEquals(decodeCursor(encodeCursor(cursor)), cursor);
  for (
    const query of [
      "",
      "?sessionId=bad",
      `?sessionId=${SESSION_ACTIVE}&limit=0`,
      `?sessionId=${SESSION_ACTIVE}&limit=101`,
      `?sessionId=${SESSION_ACTIVE}&limit=01`,
      `?sessionId=${SESSION_ACTIVE}&cursor=broken`,
      `?sessionId=${SESSION_ACTIVE}&userId=x`,
      `?sessionId=${SESSION_ACTIVE}&specialistId=x`,
      `?sessionId=${SESSION_ACTIVE}&role=user`,
      `?sessionId=${SESSION_ACTIVE}&prompt_template=x`,
      `?sessionId=${SESSION_ACTIVE}&attachments=x`,
      `?sessionId=${SESSION_ACTIVE}&metadata=x`,
      `?sessionId=${SESSION_ACTIVE}&sessionId=${SESSION_ACTIVE}`,
    ]
  ) {
    await assertRejects(
      async () => parseListMessagesRequest(new URL(request(query).url)),
      Error,
    );
  }
});

Deno.test("response is public, metadata-backed and safely paginated", () => {
  const rows = [
    messageRow(
      "5d500000-0000-4000-8000-000000000001",
      "2026-06-21T10:00:00Z",
      "user",
    ),
    messageRow(
      "5d500000-0000-4000-8000-000000000002",
      "2026-06-21T10:00:00Z",
      "user",
    ),
    messageRow(
      "5d500000-0000-4000-8000-000000000003",
      "2026-06-21T10:01:00Z",
      "user",
    ),
  ];
  const first = buildMessagesResponse(rows, 2);
  assertEquals(first.items.map((item) => item.messageId), [
    "5d500000-0000-4000-8000-000000000001",
    "5d500000-0000-4000-8000-000000000002",
  ]);
  assertEquals(first.nextCursor !== null, true);
  const second = buildMessagesResponse([rows[2]], 2);
  const firstIds = new Set(first.items.map((item) => item.messageId));
  assertEquals(
    second.items.some((item) => firstIds.has(item.messageId)),
    false,
  );
  assertEquals(second.nextCursor, null);
  const serialized = JSON.stringify(first);
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

Deno.test("assistant, tool, internal and unknown rows fail closed at DTO boundary", async () => {
  for (
    const row of [
      messageRow(
        "5d500000-0000-4000-8000-000000000008",
        "2026-06-21T10:00:00Z",
        "assistant",
      ),
      messageRow(
        "5d500000-0000-4000-8000-000000000009",
        "2026-06-21T10:00:00Z",
        "tool",
      ),
      {
        ...messageRow(
          "5d500000-0000-4000-8000-000000000010",
          "2026-06-21T10:00:00Z",
        ),
        visibility_type: "internal",
      },
      {
        ...messageRow(
          "5d500000-0000-4000-8000-000000000011",
          "2026-06-21T10:00:00Z",
        ),
        visibility_type: "unknown",
      },
    ]
  ) {
    await assertRejects(
      async () => buildMessagesResponse([row], 1),
      Error,
      "contractViolation",
    );
  }
});

Deno.test("redacted DTO omits content rather than masking the original", () => {
  const row = {
    ...messageRow(
      "5d500000-0000-4000-8000-000000000012",
      "2026-06-21T10:00:00Z",
    ),
    content: null,
    visibility_type: "redacted",
    message_status: "redacted",
  };
  const message = buildMessagesResponse([row], 1).items[0];
  assertEquals(Object.hasOwn(message, "content"), false);
  assertEquals(message.visibility, "redacted");
});

Deno.test("handler validates owner, reads only session messages and does no writes", async () => {
  const paths: Array<{ path: string; method: string; query: string }> = [];
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request, init?: RequestInit) => {
      const url = new URL(input instanceof Request ? input.url : input);
      paths.push({
        path: url.pathname,
        method: init?.method ?? "GET",
        query: url.search,
      });
      if (url.pathname === "/auth/v1/user") {
        return Response.json({ id: OWNER_A });
      }
      if (url.pathname === "/rest/v1/rpc/list_own_conversation_messages_core") {
        return Response.json([
          messageRow(
            "5d500000-0000-4000-8000-000000000001",
            "2026-06-21T10:00:00Z",
            "user",
            SESSION_ARCHIVED,
          ),
        ]);
      }
      return new Response(null, { status: 404 });
    }) as typeof fetch,
    logWriter: () => {},
  });
  const response = await handler(request(`?sessionId=${SESSION_ARCHIVED}`));
  const body = await response.json();
  assertEquals(response.status, 200);
  assertEquals(body.items.length, 1);
  assertEquals(paths.map((entry) => entry.path), [
    "/auth/v1/user",
    "/rest/v1/rpc/list_own_conversation_messages_core",
  ]);
  assertEquals(
    paths.some((entry) =>
      ["POST", "PATCH", "PUT", "DELETE"].includes(entry.method)
    ),
    false,
  );
  const messageQuery = new URL(`http://local${paths[1].query}`).searchParams;
  assertEquals(messageQuery.get("p_session_id"), SESSION_ARCHIVED);
  assertEquals(messageQuery.get("p_owner_user_id"), OWNER_A);
  assertEquals(messageQuery.get("p_limit"), "51");
});

Deno.test("foreign and missing sessions are indistinguishable", async () => {
  const handler = createHandler(LOCAL_CONFIG, {
    fetcher: (async (input: string | URL | Request) => {
      const url = new URL(input instanceof Request ? input.url : input);
      if (url.pathname === "/auth/v1/user") {
        return Response.json({ id: OWNER_A });
      }
      if (url.pathname === "/rest/v1/rpc/list_own_conversation_messages_core") {
        return Response.json({ message: "session_not_found" }, { status: 400 });
      }
      return new Response(null, { status: 404 });
    }) as typeof fetch,
    requestId: () => "request-test",
    logWriter: () => {},
  });
  const foreign = await handler(request(`?sessionId=${SESSION_ACTIVE}`));
  const missing = await handler(request(`?sessionId=${SESSION_ARCHIVED}`));
  assertEquals(foreign.status, 404);
  assertEquals(missing.status, 404);
  assertEquals(await foreign.json(), {
    error: { code: "sessionNotFound", requestId: "request-test" },
  });
  assertEquals(await missing.json(), {
    error: { code: "sessionNotFound", requestId: "request-test" },
  });
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

Deno.test("JWT, runtime and logs fail closed", async () => {
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
    operation: "conversation.message.listOwn",
    result: "success",
    latency: 1,
    count: 2,
    contract_version: "1",
    request_id: "opaque",
  }, (value) => serialized = value);
  for (
    const forbidden of [
      "user_id",
      "specialist_id",
      "JWT",
      "service_role",
      SESSION_ACTIVE,
    ]
  ) {
    assertEquals(serialized.includes(forbidden), false);
  }
});
