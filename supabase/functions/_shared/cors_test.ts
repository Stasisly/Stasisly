import { assertEquals } from "jsr:@std/assert@1";
import { corsHeadersFor, preflightResponse } from "./cors.ts";

const METHODS = ["POST", "OPTIONS"];

Deno.test("cors preflight allows local origins without auth", () => {
  const request = new Request("http://localhost/functions/v1/example", {
    method: "OPTIONS",
    headers: { origin: "http://localhost:3000" },
  });

  const response = preflightResponse(
    request,
    { corsAllowedOrigins: "" },
    METHODS,
  );

  assertEquals(response.status, 204);
  assertEquals(
    response.headers.get("access-control-allow-origin"),
    "http://localhost:3000",
  );
  assertEquals(
    response.headers.get("access-control-allow-headers"),
    "authorization, content-type, apikey",
  );
});

Deno.test("cors does not wildcard unapproved remote origins", () => {
  const request = new Request("https://example.test/functions/v1/example", {
    headers: { origin: "https://unapproved.example" },
  });

  const headers = new Headers(
    corsHeadersFor(request, { corsAllowedOrigins: "" }, METHODS),
  );

  assertEquals(headers.get("access-control-allow-origin"), null);
});

Deno.test("cors allows configured development origins exactly", () => {
  const request = new Request("https://example.test/functions/v1/example", {
    headers: { origin: "https://dev.stasisly.example" },
  });

  const headers = new Headers(
    corsHeadersFor(
      request,
      { corsAllowedOrigins: "https://dev.stasisly.example" },
      METHODS,
    ),
  );

  assertEquals(
    headers.get("access-control-allow-origin"),
    "https://dev.stasisly.example",
  );
});
