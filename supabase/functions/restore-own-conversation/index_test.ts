import { assertEquals } from "jsr:@std/assert@1";
import { createHandler, type RuntimeConfig } from "./index.ts";
const OWNER = "41000000-0000-4000-8000-000000000001";
const CONVERSATION = "44000000-0000-4000-8000-000000000001";
const CONFIG: RuntimeConfig = {
  supabaseUrl: "http://127.0.0.1:54321",
  anonKey: "local-anon",
  serviceRoleKey: "local-service",
  allowLocalOnly: "true",
  runtimeMode: "local",
  allowDevelopmentRemote: "false",
  corsAllowedOrigins: "",
};
function request(body: unknown = { conversationId: CONVERSATION }) {
  return new Request(
    "http://127.0.0.1:54321/functions/v1/restore-own-conversation",
    {
      method: "POST",
      headers: {
        authorization: "Bearer jwt",
        "content-type": "application/json",
      },
      body: JSON.stringify(body),
    },
  );
}
Deno.test("restore invokes narrow owner-scoped RPC and returns active receipt", async () => {
  let rpcBody = "";
  const handler = createHandler(CONFIG, {
    fetcher: (async (input: string | URL | Request, init?: RequestInit) => {
      const path =
        new URL(input instanceof Request ? input.url : input).pathname;
      if (path === "/auth/v1/user") return Response.json({ id: OWNER });
      if (path === "/rest/v1/rpc/restore_own_conversation_core") {
        rpcBody = String(init?.body);
        return Response.json([{
          conversation_id: CONVERSATION,
          status: "active",
        }]);
      }
      return new Response(null, { status: 404 });
    }) as typeof fetch,
  });
  const response = await handler(request());
  assertEquals(response.status, 200);
  assertEquals(JSON.parse(rpcBody), {
    p_owner_user_id: OWNER,
    p_conversation_id: CONVERSATION,
  });
  assertEquals(await response.json(), {
    conversation: { conversationId: CONVERSATION, status: "active" },
  });
});
Deno.test("restore replay has the same successful contract", async () => {
  const handler = createHandler(CONFIG, {
    fetcher: (async (input: string | URL | Request) =>
      new URL(input instanceof Request ? input.url : input).pathname ===
          "/auth/v1/user"
        ? Response.json({ id: OWNER })
        : Response.json([{
          conversation_id: CONVERSATION,
          status: "active",
        }])) as typeof fetch,
  });
  assertEquals((await handler(request())).status, 200);
  assertEquals((await handler(request())).status, 200);
});
Deno.test("foreign restore remains opaque", async () => {
  const handler = createHandler(CONFIG, {
    fetcher: (async (input: string | URL | Request) =>
      new URL(input instanceof Request ? input.url : input).pathname ===
          "/auth/v1/user"
        ? Response.json({ id: OWNER })
        : Response.json({ message: "conversation_not_found" }, {
          status: 400,
        })) as typeof fetch,
    requestId: () =>
      "same",
  });
  const response = await handler(request());
  assertEquals(response.status, 404);
  assertEquals(await response.json(), {
    error: { code: "conversationNotFound", requestId: "same" },
  });
});
Deno.test("restore rejects authority fields and malformed result", async () => {
  let calls = 0;
  const blocked = createHandler(CONFIG, {
    fetcher: (() => {
      calls++;
      return Promise.reject(new Error("no backend"));
    }) as typeof fetch,
  });
  assertEquals(
    (await blocked(request({ conversationId: CONVERSATION, role: "owner" })))
      .status,
    400,
  );
  assertEquals(calls, 0);
  const malformed = createHandler(CONFIG, {
    fetcher: (async (input: string | URL | Request) =>
      new URL(input instanceof Request ? input.url : input).pathname ===
          "/auth/v1/user"
        ? Response.json({ id: OWNER })
        : Response.json([{
          conversation_id: CONVERSATION,
          status: "archived",
        }])) as typeof fetch,
  });
  assertEquals((await malformed(request())).status, 502);
});
