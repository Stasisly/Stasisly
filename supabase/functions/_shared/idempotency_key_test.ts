import { assertEquals, assertRejects } from "jsr:@std/assert@1";
import { requireIdempotencyKey } from "./idempotency_key.ts";

Deno.test("idempotency key requires bounded opaque header", async () => {
  const valid = "operation_7d9e1f2a3b4c";
  assertEquals(
    requireIdempotencyKey(
      new Request("http://localhost", {
        headers: { "Idempotency-Key": valid },
      }),
    ),
    valid,
  );
  await assertRejects(
    async () => requireIdempotencyKey(new Request("http://localhost")),
    Error,
    "missingIdempotencyKey",
  );
  for (const invalid of ["short", "contains space value", "a".repeat(129)]) {
    await assertRejects(
      async () =>
        requireIdempotencyKey(
          new Request("http://localhost", {
            headers: { "Idempotency-Key": invalid },
          }),
        ),
      Error,
      "invalidIdempotencyKey",
    );
  }
});
