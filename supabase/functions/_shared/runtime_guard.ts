export type StasislyRuntimeMode =
  | "local"
  | "development"
  | "staging"
  | "production"
  | "unknown";

export interface RuntimeGuardConfig {
  supabaseUrl: string;
  anonKey: string;
  serviceRoleKey: string;
  allowLocalOnly: string;
  runtimeMode: string;
  allowDevelopmentRemote: string;
}

const LOCAL_ENDPOINTS = new Set([
  "127.0.0.1:54321",
  "localhost:54321",
  "host.docker.internal:54321",
  "kong:8000",
]);

function normalizeRuntimeMode(rawMode: string): StasislyRuntimeMode {
  if (
    rawMode === "local" ||
    rawMode === "development" ||
    rawMode === "staging" ||
    rawMode === "production"
  ) {
    return rawMode;
  }
  return "unknown";
}

function parseSupabaseUrl(rawUrl: string): URL {
  try {
    return new URL(rawUrl);
  } catch {
    throw new Error("backendMisconfigured");
  }
}

function hasRequiredSecrets(config: RuntimeGuardConfig): boolean {
  return config.anonKey.length > 0 && config.serviceRoleKey.length > 0;
}

export function assertAllowedRuntime(config: RuntimeGuardConfig): URL {
  if (!hasRequiredSecrets(config)) {
    throw new Error("backendMisconfigured");
  }

  const url = parseSupabaseUrl(config.supabaseUrl);
  const mode = normalizeRuntimeMode(config.runtimeMode);
  const localEndpoint = url.protocol === "http:" && LOCAL_ENDPOINTS.has(
    url.host,
  );

  // Backward-compatible local behavior for existing local harnesses that only
  // set STASISLY_ALLOW_LOCAL_ONLY=true.
  if (
    (mode === "local" || mode === "unknown") &&
    config.allowLocalOnly === "true" &&
    localEndpoint
  ) {
    return url;
  }

  if (
    mode === "development" &&
    config.allowDevelopmentRemote === "true" &&
    url.protocol === "https:" &&
    !LOCAL_ENDPOINTS.has(url.host)
  ) {
    return url;
  }

  throw new Error("backendMisconfigured");
}
