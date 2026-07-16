const IDEMPOTENCY_KEY_PATTERN = /^[A-Za-z0-9._~-]{16,128}$/;

export function requireIdempotencyKey(request: Request): string {
  const key = request.headers.get("Idempotency-Key");
  if (key === null) throw new Error("missingIdempotencyKey");
  if (!IDEMPOTENCY_KEY_PATTERN.test(key)) {
    throw new Error("invalidIdempotencyKey");
  }
  return key;
}
