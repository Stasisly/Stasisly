import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import {
  parseConversationBody,
  sanitizeConversation,
} from "../_shared/conversation_contract.ts";
import { createHandler, type RuntimeConfig } from "./index.ts";

const OWNER = "41000000-0000-4000-8000-000000000001";
const CONVERSATION = "44000000-0000-4000-8000-000000000001";
const SELECTABLE = "43000000-0000-4000-8000-000000000001";
const CONFIG: RuntimeConfig = {
  supabaseUrl: "http://127.0.0.1:54321",
  anonKey: "local-anon",
  serviceRoleKey: "local-service",
  allowLocalOnly: "true",
  runtimeMode: "local",
  allowDevelopmentRemote: "false",
  corsAllowedOrigins: "",
};
function request(
  body: unknown = { conversationId: CONVERSATION },
  token = "jwt",
) {
  return new Request(
    "http://127.0.0.1:54321/functions/v1/read-own-conversation",
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
function row(status: "active" | "archived" = "active") {
  return {
    conversation_id: CONVERSATION,
    status,
    created_at: "2026-01-01T00:00:00Z",
    updated_at: "2026-01-02T00:00:00Z",
    archived_at: status === "archived" ? "2026-01-03T00:00:00Z" : null,
    selectable_specialist_id: SELECTABLE,
    specialist_display_name: "Synthetic",
    product_area: "health",
  };
}

Deno.test("read body accepts only canonical ConversationId", async () => {
  assertEquals(await parseConversationBody(request()), CONVERSATION);
  for (
    const body of [{}, { conversationId: CONVERSATION, userId: OWNER }, {
      sessionId: CONVERSATION,
    }, { conversationId: "bad" }]
  ) {
    await assertRejects(
      () => parseConversationBody(request(body)),
      Error,
      "invalidRequest",
    );
  }
});
Deno.test("canonical read DTO is exact and lifecycle-aware", async () => {
  assertEquals(
    sanitizeConversation([row("archived")], CONVERSATION).status,
    "archived",
  );
  await assertRejects(
    async () =>
      sanitizeConversation([{ ...row(), ownerSubjectId: OWNER }], CONVERSATION),
    Error,
    "contractViolation",
  );
  await assertRejects(
    async () =>
      sanitizeConversation(
        [{ ...row(), archived_at: "2026-01-03T00:00:00Z" }],
        CONVERSATION,
      ),
    Error,
    "contractViolation",
  );
});
Deno.test("read handler derives owner and returns sanitized DTO", async () => {
  let rpcBody = "";
  const handler = createHandler(CONFIG, {
    fetcher: (async (input: string | URL | Request, init?: RequestInit) => {
      const path =
        new URL(input instanceof Request ? input.url : input).pathname;
      if (path === "/auth/v1/user") return Response.json({ id: OWNER });
      if (path === "/rest/v1/rpc/read_own_conversation_core") {
        rpcBody = String(init?.body);
        return Response.json([row("archived")]);
      }
      return new Response(null, { status: 404 });
    }) as typeof fetch,
    requestId: () => "request-id",
  });
  const response = await handler(request());
  assertEquals(response.status, 200);
  assertEquals(JSON.parse(rpcBody), {
    p_owner_user_id: OWNER,
    p_conversation_id: CONVERSATION,
  });
  const serialized = JSON.stringify(await response.json());
  for (const forbidden of ["ownerSubjectId", "user_id", "specialist_id"]) {
    assertEquals(serialized.includes(forbidden), false);
  }
});
Deno.test("foreign and missing reads are opaque 404", async () => {
  const handler = createHandler(CONFIG, {
    fetcher: (async (input: string | URL | Request) => {
      const path =
        new URL(input instanceof Request ? input.url : input).pathname;
      if (path === "/auth/v1/user") return Response.json({ id: OWNER });
      return Response.json({ message: "conversation_not_found" }, {
        status: 400,
      });
    }) as typeof fetch,
    requestId: () => "same",
  });
  const response = await handler(request());
  assertEquals(response.status, 404);
  assertEquals(await response.json(), {
    error: { code: "conversationNotFound", requestId: "same" },
  });
});
Deno.test("read rejects missing auth and authority headers before RPC", async () => {
  let calls = 0;
  const handler = createHandler(CONFIG, {
    fetcher: (async () => {
      calls++;
      return new Response(null, { status: 401 });
    }) as typeof fetch,
  });
  const noAuth = request();
  noAuth.headers.delete("authorization");
  assertEquals((await handler(noAuth)).status, 401);
  const authority = request();
  authority.headers.set("x-stasisly-surface", "product");
  assertEquals((await handler(authority)).status, 400);
  assertEquals(calls, 0);
});
