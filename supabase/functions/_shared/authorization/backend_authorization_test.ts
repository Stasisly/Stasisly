import { assertEquals, assertRejects, assertThrows } from "jsr:@std/assert@1";
import {
  BackendAuthorizationEnforcer,
} from "./backend_authorization_enforcer.ts";
import { BackendAuthorizationError } from "./backend_authorization_decision.ts";
import {
  BACKEND_OPERATIONS,
  type BackendOperationDefinition,
} from "./backend_operation_definition.ts";
import type { BackendAuthorizationPolicyDecisionPoint } from "./backend_policy_decision_point.ts";
import {
  type BackendRequestContext,
  buildBackendRequestContext,
} from "./backend_request_context.ts";
import { verifyBackendHumanIdentity } from "./backend_identity.ts";
import { FoundationLocalBackendPolicy } from "./foundation_local_policy.ts";
import {
  assertNoClientAuthorityMetadata,
  resolveCorrelationId,
} from "./request_metadata.ts";

const IDENTITY = Object.freeze({
  subjectId: "10000000-0000-4000-8000-000000000001",
  identityType: "human" as const,
  authenticationState: "authenticated" as const,
});

function validContext(
  operation: BackendOperationDefinition =
    BACKEND_OPERATIONS.listSelectableSpecialists,
): BackendRequestContext {
  return buildBackendRequestContext({
    operation,
    environment: "local",
    identity: IDENTITY,
    correlationId: "request-1",
    ownershipState: operation.ownershipRequired ? "owned" : "notApplicable",
  });
}

function changed(
  context: BackendRequestContext,
  values: Partial<BackendRequestContext>,
): BackendRequestContext {
  return Object.freeze({ ...context, ...values });
}

Deno.test("all eight backend operations are registered Product local/development contracts", () => {
  assertEquals(Object.keys(BACKEND_OPERATIONS).sort(), [
    "archiveOwnChatSession",
    "createOwnChatSession",
    "listOwnChatSessions",
    "listSelectableSpecialists",
    "listSessionMessages",
    "readOwnConversation",
    "restoreOwnConversation",
    "sendUserMessage",
  ]);
  for (const operation of Object.values(BACKEND_OPERATIONS)) {
    assertEquals(operation.expectedSurface, "product");
    assertEquals(operation.allowedEnvironments, ["local", "development"]);
    assertEquals(operation.authenticationRequired, true);
    assertEquals(operation.entitlementRequired, false);
  }
  assertEquals(
    BACKEND_OPERATIONS.sendUserMessage.operationId,
    "conversation.message.sendUser",
  );
  assertEquals(
    BACKEND_OPERATIONS.listSessionMessages.operationId,
    "conversation.message.listOwn",
  );
  const serialized = JSON.stringify(BACKEND_OPERATIONS);
  for (
    const futureOperation of [
      "appendStasis",
      "appendSpecialist",
      "appendSystemNotice",
      "conversation.message.redact",
    ]
  ) {
    assertEquals(serialized.includes(futureOperation), false);
  }
});

Deno.test("local policy allows valid local and development contexts", () => {
  const policy = new FoundationLocalBackendPolicy();
  for (const environment of ["local", "development"] as const) {
    const context = changed(validContext(), { environment });
    assertEquals(
      policy.decide(
        context,
        BACKEND_OPERATIONS.listSelectableSpecialists,
        "final",
      ).type,
      "allow",
    );
  }
});

Deno.test("missing authentication and invalid authentication deny", () => {
  const policy = new FoundationLocalBackendPolicy();
  const operation = BACKEND_OPERATIONS.listSelectableSpecialists;
  const context = validContext(operation);
  assertEquals(
    policy.decide(
      changed(context, {
        identitySubjectId: null,
        authenticationState: "unauthenticated",
      }),
      operation,
      "final",
    ).reasonCode,
    "unauthenticated",
  );
  assertEquals(
    policy.decide(
      changed(context, { authenticationState: "invalid" }),
      operation,
      "final",
    ).reasonCode,
    "invalidAuthentication",
  );
});

Deno.test("unknown and mismatched surface deny", () => {
  const policy = new FoundationLocalBackendPolicy();
  const operation = BACKEND_OPERATIONS.listSelectableSpecialists;
  const context = validContext(operation);
  assertEquals(
    policy.decide(
      changed(context, { surface: "unknown" }),
      operation,
      "final",
    ).reasonCode,
    "unknownSurface",
  );
  assertEquals(
    policy.decide(
      changed(context, { surface: "development" }),
      operation,
      "final",
    ).reasonCode,
    "surfaceMismatch",
  );
});

Deno.test("unknown staging and production environments deny", () => {
  const policy = new FoundationLocalBackendPolicy();
  const operation = BACKEND_OPERATIONS.listSelectableSpecialists;
  const context = validContext(operation);
  assertEquals(
    policy.decide(
      changed(context, { environment: "unknown" }),
      operation,
      "final",
    ).reasonCode,
    "unknownEnvironment",
  );
  for (const environment of ["staging", "production"] as const) {
    assertEquals(
      policy.decide(
        changed(context, { environment }),
        operation,
        "final",
      ).reasonCode,
      "environmentBlocked",
    );
  }
});

Deno.test("unknown and conflicting action or resource deny", () => {
  const policy = new FoundationLocalBackendPolicy();
  const operation = BACKEND_OPERATIONS.listSelectableSpecialists;
  const context = validContext(operation);
  assertEquals(
    policy.decide(
      changed(context, { action: "unknown" }),
      operation,
      "final",
    ).reasonCode,
    "unknownAction",
  );
  assertEquals(
    policy.decide(
      changed(context, { action: "create" }),
      operation,
      "final",
    ).reasonCode,
    "explicitDeny",
  );
  assertEquals(
    policy.decide(
      changed(context, { resourceType: "unknown" }),
      operation,
      "final",
    ).reasonCode,
    "unknownResource",
  );
  assertEquals(
    policy.decide(
      changed(context, { resourceType: "chatSession" }),
      operation,
      "final",
    ).reasonCode,
    "explicitDeny",
  );
});

Deno.test("ownership is deferred only during preflight and enforced finally", () => {
  const policy = new FoundationLocalBackendPolicy();
  const operation = BACKEND_OPERATIONS.createOwnChatSession;
  const context = changed(validContext(operation), {
    ownershipState: "unknown",
  });
  assertEquals(policy.decide(context, operation, "preflight").type, "allow");
  assertEquals(
    policy.decide(context, operation, "final").reasonCode,
    "ownershipRequired",
  );
  assertEquals(
    policy.decide(
      changed(context, { ownershipState: "notOwned" }),
      operation,
      "final",
    ).reasonCode,
    "ownershipMismatch",
  );
});

Deno.test("unregistered operation and malformed context deny", () => {
  const policy = new FoundationLocalBackendPolicy();
  const registered = BACKEND_OPERATIONS.listSelectableSpecialists;
  const clone = { ...registered } as BackendOperationDefinition;
  assertEquals(
    policy.decide(validContext(registered), clone, "final").reasonCode,
    "operationNotRegistered",
  );
  assertEquals(
    policy.decide(
      changed(validContext(registered), { requestSource: "unknown" }),
      registered,
      "final",
    ).reasonCode,
    "missingAuthorizationContext",
  );
});

Deno.test("enforcer denies unavailable and failing policies", () => {
  assertEquals(
    new BackendAuthorizationEnforcer(null).evaluate(
      validContext(),
      BACKEND_OPERATIONS.listSelectableSpecialists,
    ).reasonCode,
    "policyUnavailable",
  );
  const failingPolicy: BackendAuthorizationPolicyDecisionPoint = {
    decide() {
      throw new Error("sensitive internal policy failure");
    },
  };
  const enforcer = new BackendAuthorizationEnforcer(failingPolicy);
  assertEquals(
    enforcer.evaluate(
      validContext(),
      BACKEND_OPERATIONS.listSelectableSpecialists,
    ).reasonCode,
    "policyError",
  );
  assertThrows(
    () =>
      enforcer.enforce(
        validContext(),
        BACKEND_OPERATIONS.listSelectableSpecialists,
      ),
    BackendAuthorizationError,
    "policyError",
  );
});

Deno.test("client authority headers and query fields are rejected", () => {
  for (
    const header of [
      "x-owner-id",
      "x-role",
      "x-stasisly-surface",
      "x-stasisly-environment",
      "x-entitlement",
    ]
  ) {
    assertThrows(
      () =>
        assertNoClientAuthorityMetadata(
          new Request("http://localhost/function", {
            headers: { [header]: "attacker" },
          }),
        ),
      BackendAuthorizationError,
      "unexpectedAuthorityField",
    );
  }
  assertThrows(
    () =>
      assertNoClientAuthorityMetadata(
        new Request("http://localhost/function?userId=attacker"),
      ),
    BackendAuthorizationError,
    "unexpectedAuthorityField",
  );
});

Deno.test("correlation IDs are bounded and non-authoritative", () => {
  assertEquals(
    resolveCorrelationId(
      new Request("http://localhost/function", {
        headers: { "x-correlation-id": "client.request-1" },
      }),
      () => "generated",
    ),
    "client.request-1",
  );
  assertEquals(
    resolveCorrelationId(
      new Request("http://localhost/function"),
      () => "generated-1",
    ),
    "generated-1",
  );
  assertThrows(
    () =>
      resolveCorrelationId(
        new Request("http://localhost/function", {
          headers: { "x-correlation-id": "secret value with spaces" },
        }),
        () => "generated",
      ),
    BackendAuthorizationError,
    "invalidCorrelationId",
  );
});

Deno.test("verified identity derives subject only from backend auth response", async () => {
  const calls: Request[] = [];
  const fetcher: typeof fetch = (input, init) => {
    calls.push(new Request(input, init));
    return Promise.resolve(Response.json({ id: IDENTITY.subjectId }));
  };
  const identity = await verifyBackendHumanIdentity(
    new Request("http://localhost/function", {
      headers: { authorization: "Bearer opaque-token" },
    }),
    fetcher,
    new URL("http://127.0.0.1:54321"),
    "anon-placeholder",
  );
  assertEquals(identity.subjectId, IDENTITY.subjectId);
  assertEquals(JSON.stringify(identity).includes("opaque-token"), false);
  assertEquals(calls.length, 1);
  assertEquals(new URL(calls[0].url).pathname, "/auth/v1/user");
});

Deno.test("missing and invalid authentication fail without provider leakage", async () => {
  await assertRejects(
    () =>
      verifyBackendHumanIdentity(
        new Request("http://localhost/function"),
        fetch,
        new URL("http://127.0.0.1:54321"),
        "anon-placeholder",
      ),
    BackendAuthorizationError,
    "unauthenticated",
  );
  await assertRejects(
    () =>
      verifyBackendHumanIdentity(
        new Request("http://localhost/function", {
          headers: { authorization: "Bearer invalid" },
        }),
        () =>
          Promise.resolve(new Response("provider details", { status: 401 })),
        new URL("http://127.0.0.1:54321"),
        "anon-placeholder",
      ),
    BackendAuthorizationError,
    "invalidAuthentication",
  );
});
