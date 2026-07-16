import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import {
  assertAllowedRuntime,
  type RuntimeGuardConfig,
} from "./runtime_guard.ts";

const BASE_CONFIG: RuntimeGuardConfig = {
  supabaseUrl: "http://127.0.0.1:54321",
  anonKey: "local-anon-placeholder",
  serviceRoleKey: "local-service-role-placeholder",
  allowLocalOnly: "true",
  runtimeMode: "local",
  allowDevelopmentRemote: "false",
};

Deno.test("runtime guard allows explicit local runtime only on local endpoints", () => {
  assertEquals(assertAllowedRuntime(BASE_CONFIG).hostname, "127.0.0.1");
});

Deno.test("runtime guard denies missing environment configuration", async () => {
  await assertRejects(
    async () => assertAllowedRuntime({ ...BASE_CONFIG, runtimeMode: "" }),
    Error,
    "backendMisconfigured",
  );
});

Deno.test("runtime guard allows development against an explicit local endpoint", () => {
  assertEquals(
    assertAllowedRuntime({ ...BASE_CONFIG, runtimeMode: "development" })
      .hostname,
    "127.0.0.1",
  );
});

Deno.test("runtime guard allows development remote only with explicit flag", () => {
  assertEquals(
    assertAllowedRuntime({
      ...BASE_CONFIG,
      supabaseUrl: "https://development.example.supabase.co",
      allowLocalOnly: "false",
      runtimeMode: "development",
      allowDevelopmentRemote: "true",
    }).protocol,
    "https:",
  );
});

Deno.test("runtime guard blocks development remote without explicit flag", async () => {
  await assertRejects(
    async () =>
      assertAllowedRuntime({
        ...BASE_CONFIG,
        supabaseUrl: "https://development.example.supabase.co",
        allowLocalOnly: "false",
        runtimeMode: "development",
      }),
    Error,
    "backendMisconfigured",
  );
});

Deno.test("runtime guard blocks staging production and unknown remote runtimes", async () => {
  for (const runtimeMode of ["staging", "production", "unknown"]) {
    await assertRejects(
      async () =>
        assertAllowedRuntime({
          ...BASE_CONFIG,
          supabaseUrl: "https://remote.example.supabase.co",
          allowLocalOnly: "false",
          runtimeMode,
          allowDevelopmentRemote: "true",
        }),
      Error,
      "backendMisconfigured",
    );
  }
});
