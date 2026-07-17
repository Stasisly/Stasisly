const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

export async function parseConversationBody(request: Request): Promise<string> {
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
    typeof record.conversationId !== "string" ||
    !UUID_PATTERN.test(record.conversationId)
  ) throw new Error("invalidRequest");
  return record.conversationId;
}

export interface PublicConversation {
  conversationId: string;
  status: "active" | "archived";
  createdAt: string;
  updatedAt: string;
  archivedAt?: string;
  selectedSpecialist?: { id: string; displayName: string; area: string };
}

export function sanitizeConversation(
  rows: unknown,
  expectedId: string,
): PublicConversation {
  if (!Array.isArray(rows) || rows.length !== 1) {
    throw new Error(
      rows instanceof Array && rows.length === 0
        ? "conversationNotFound"
        : "contractViolation",
    );
  }
  const value = rows[0];
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error("contractViolation");
  }
  const row = value as Record<string, unknown>;
  const expected = [
    "archived_at",
    "conversation_id",
    "created_at",
    "product_area",
    "selectable_specialist_id",
    "specialist_display_name",
    "status",
    "updated_at",
  ].sort();
  const keys = Object.keys(row).sort();
  if (
    keys.length !== expected.length ||
    !keys.every((key, index) => key === expected[index]) ||
    row.conversation_id !== expectedId ||
    !["active", "archived"].includes(String(row.status)) ||
    typeof row.created_at !== "string" ||
    typeof row.updated_at !== "string" ||
    !Number.isFinite(Date.parse(row.created_at)) ||
    !Number.isFinite(Date.parse(row.updated_at)) ||
    !UUID_PATTERN.test(String(row.selectable_specialist_id)) ||
    typeof row.specialist_display_name !== "string" ||
    row.specialist_display_name.length === 0 ||
    typeof row.product_area !== "string" || row.product_area.length === 0 ||
    (row.status === "active" && row.archived_at !== null) ||
    (row.status === "archived" &&
      (typeof row.archived_at !== "string" ||
        !Number.isFinite(Date.parse(row.archived_at))))
  ) throw new Error("contractViolation");
  return {
    conversationId: expectedId,
    status: row.status as "active" | "archived",
    createdAt: row.created_at,
    updatedAt: row.updated_at,
    ...(typeof row.archived_at === "string"
      ? { archivedAt: row.archived_at }
      : {}),
    selectedSpecialist: {
      id: row.selectable_specialist_id as string,
      displayName: row.specialist_display_name as string,
      area: row.product_area as string,
    },
  };
}
