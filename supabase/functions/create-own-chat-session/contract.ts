const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

const PRODUCT_AREAS = [
  "stasis",
  "health",
  "nutrition",
  "training",
  "wellness",
];

const RPC_KEYS = [
  "idempotent_replay",
  "last_message_at",
  "message_count",
  "product_area",
  "selectable_specialist_id",
  "session_id",
  "specialist_display_name",
  "started_at",
  "status",
].sort();

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

export interface SanitizedCreatedSession {
  session: PublicSession;
  idempotentReplay: boolean;
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

export function sanitizeCreatedSession(rows: unknown): SanitizedCreatedSession {
  if (!Array.isArray(rows) || rows.length !== 1) {
    throw new Error("contractViolation");
  }
  const value = rows[0];
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error("contractViolation");
  }
  const row = value as Record<string, unknown>;
  assertExactKeys(row, RPC_KEYS);
  if (
    !UUID_PATTERN.test(String(row.session_id)) ||
    !UUID_PATTERN.test(String(row.selectable_specialist_id)) ||
    typeof row.started_at !== "string" ||
    typeof row.last_message_at !== "string" ||
    row.status !== "active" ||
    row.message_count !== 0 ||
    typeof row.specialist_display_name !== "string" ||
    row.specialist_display_name.length === 0 ||
    typeof row.product_area !== "string" ||
    !PRODUCT_AREAS.includes(row.product_area) ||
    typeof row.idempotent_replay !== "boolean"
  ) {
    throw new Error("contractViolation");
  }
  return {
    session: {
      sessionId: row.session_id as string,
      selectableSpecialist: {
        id: row.selectable_specialist_id as string,
        displayName: row.specialist_display_name,
        area: row.product_area,
      },
      startedAt: row.started_at,
      lastMessageAt: row.last_message_at,
      status: "active",
      messageCount: 0,
    },
    idempotentReplay: row.idempotent_replay,
  };
}
