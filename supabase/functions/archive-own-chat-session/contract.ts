const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export async function parseArchiveBody(request: Request): Promise<string> {
  let body: unknown;
  try {
    body = await request.json();
  } catch {
    throw new Error("invalidRequest");
  }
  if (typeof body !== "object" || body === null || Array.isArray(body)) {
    throw new Error("invalidRequest");
  }
  const record = body as Record<string, unknown>;
  if (
    Object.keys(record).length !== 1 ||
    !Object.hasOwn(record, "sessionId") ||
    typeof record.sessionId !== "string" ||
    !UUID_PATTERN.test(record.sessionId)
  ) throw new Error("invalidRequest");
  return record.sessionId;
}

export function sanitizeArchiveResult(
  rows: unknown,
  expectedSessionId: string,
): { sessionId: string; status: "archived" } {
  if (!Array.isArray(rows)) throw new Error("contractViolation");
  if (rows.length === 0) throw new Error("sessionNotFound");
  if (rows.length !== 1) throw new Error("archiveUnconfirmed");
  const value = rows[0];
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error("contractViolation");
  }
  const record = value as Record<string, unknown>;
  const keys = Object.keys(record).sort();
  if (
    keys.length !== 2 || keys[0] !== "id" || keys[1] !== "status" ||
    record.id !== expectedSessionId || record.status !== "archived"
  ) throw new Error("contractViolation");
  return { sessionId: expectedSessionId, status: "archived" };
}
