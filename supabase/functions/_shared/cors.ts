export interface CorsConfig {
  corsAllowedOrigins: string;
}

const DEFAULT_LOCAL_ORIGINS = [
  /^http:\/\/localhost(?::\d+)?$/u,
  /^http:\/\/127\.0\.0\.1(?::\d+)?$/u,
];

function configuredOrigins(rawOrigins: string): Set<string> {
  return new Set(
    rawOrigins
      .split(",")
      .map((origin) => origin.trim())
      .filter((origin) => origin.length > 0 && origin !== "*"),
  );
}

function isAllowedOrigin(origin: string, config: CorsConfig): boolean {
  if (configuredOrigins(config.corsAllowedOrigins).has(origin)) {
    return true;
  }
  return DEFAULT_LOCAL_ORIGINS.some((pattern) => pattern.test(origin));
}

export function corsHeadersFor(
  request: Request,
  config: CorsConfig,
  methods: readonly string[],
): HeadersInit {
  const origin = request.headers.get("origin") ?? "";
  const headers: Record<string, string> = {
    "access-control-allow-methods": methods.join(", "),
    "access-control-allow-headers": "authorization, content-type, apikey",
    "access-control-max-age": "86400",
    vary: "Origin",
  };

  if (origin && isAllowedOrigin(origin, config)) {
    headers["access-control-allow-origin"] = origin;
  }

  return headers;
}

export function preflightResponse(
  request: Request,
  config: CorsConfig,
  methods: readonly string[],
): Response {
  return new Response(null, {
    status: 204,
    headers: corsHeadersFor(request, config, methods),
  });
}

export function withCorsHeaders(
  response: Response,
  request: Request,
  config: CorsConfig,
  methods: readonly string[],
): Response {
  const headers = corsHeadersFor(request, config, methods);
  for (const [key, value] of Object.entries(headers)) {
    response.headers.set(key, value);
  }
  return response;
}
