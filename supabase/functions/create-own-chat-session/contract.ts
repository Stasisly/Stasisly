const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

const CATALOG_KEYS = [
  "access_tier",
  "availability_status",
  "display_name",
  "id",
  "is_published",
  "product_area",
  "specialist_id",
].sort();

const SESSION_KEYS = [
  "id",
  "last_message_at",
  "message_count",
  "started_at",
  "status",
].sort();

export interface ResolvedSpecialist {
  selectableId: string;
  internalId: string;
  displayName: string;
  area: string;
}

export interface PublicSession {
  sessionId: string;
  selectableSpecialist: {
    id: string;
    displayName: string;
    area: string;
  };
  startedAt: string;
  lastMessageAt: string;
  status: "active";
  messageCount: 0;
}

function assertExactKeys(
  value: Record<string, unknown>,
  expected: string[],
): void {
  const actual = Object.keys(value).sort();
  if (
    actual.length !== expected.length ||
    actual.some((key, index) => key !== expected[index])
  ) {
    throw new Error("contractViolation");
  }
}

export async function parseRequestBody(request: Request): Promise<string> {
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
    !Object.hasOwn(record, "selectableSpecialistId") ||
    typeof record.selectableSpecialistId !== "string" ||
    !UUID_PATTERN.test(record.selectableSpecialistId)
  ) {
    throw new Error("invalidRequest");
  }
  return record.selectableSpecialistId;
}

export function resolveSpecialist(rows: unknown): ResolvedSpecialist {
  if (!Array.isArray(rows) || rows.length !== 1) {
    throw new Error("invalidSelectableSpecialist");
  }
  const value = rows[0];
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error("contractViolation");
  }
  const row = value as Record<string, unknown>;
  assertExactKeys(row, CATALOG_KEYS);
  if (
    !UUID_PATTERN.test(String(row.id)) ||
    !UUID_PATTERN.test(String(row.specialist_id)) ||
    row.is_published !== true ||
    typeof row.display_name !== "string" ||
    row.display_name.length === 0 ||
    typeof row.product_area !== "string" ||
    row.product_area.length === 0
  ) {
    throw new Error("contractViolation");
  }
  if (row.availability_status !== "available") {
    throw new Error("specialistUnavailable");
  }
  if (row.access_tier === "premium") throw new Error("premiumLocked");
  if (row.access_tier !== "free") throw new Error("contractViolation");
  return {
    selectableId: row.id as string,
    internalId: row.specialist_id as string,
    displayName: row.display_name,
    area: row.product_area,
  };
}

export function assertInternalSpecialistExists(rows: unknown): void {
  if (
    !Array.isArray(rows) || rows.length !== 1 ||
    typeof rows[0] !== "object" || rows[0] === null ||
    Object.keys(rows[0] as Record<string, unknown>).length !== 1 ||
    typeof (rows[0] as Record<string, unknown>).id !== "string"
  ) {
    throw new Error("specialistUnavailable");
  }
}

export function sanitizeCreatedSession(
  rows: unknown,
  specialist: ResolvedSpecialist,
): PublicSession {
  if (!Array.isArray(rows) || rows.length !== 1) {
    throw new Error("contractViolation");
  }
  const value = rows[0];
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error("contractViolation");
  }
  const row = value as Record<string, unknown>;
  assertExactKeys(row, SESSION_KEYS);
  if (
    !UUID_PATTERN.test(String(row.id)) ||
    typeof row.started_at !== "string" ||
    typeof row.last_message_at !== "string" ||
    row.status !== "active" ||
    row.message_count !== 0
  ) {
    throw new Error("contractViolation");
  }
  return {
    sessionId: row.id as string,
    selectableSpecialist: {
      id: specialist.selectableId,
      displayName: specialist.displayName,
      area: specialist.area,
    },
    startedAt: row.started_at,
    lastMessageAt: row.last_message_at,
    status: "active",
    messageCount: 0,
  };
}
