const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const SESSION_KEYS = [
  "archived_at",
  "conversation_id",
  "message_count",
  "product_area",
  "selectable_specialist_id",
  "specialist_display_name",
  "status",
  "created_at",
  "updated_at",
].sort();

export type StatusFilter = "active" | "archived" | "all";

export interface CursorValue {
  v: 1;
  lastMessageAt: string;
  sessionId: string;
}

export interface ListRequest {
  status: StatusFilter;
  limit: number;
  cursor?: CursorValue;
}

interface InternalSession {
  id: string;
  selectableSpecialistId: string;
  specialistDisplayName: string;
  productArea: string;
  createdAt: string;
  updatedAt: string;
  status: "active" | "archived";
  messageCount: number;
}

export interface PublicSession {
  sessionId: string;
  selectableSpecialist: { id: string; displayName: string; area: string };
  startedAt: string;
  lastMessageAt: string;
  status: "active" | "archived";
  messageCount: number;
}

function exactKeys(row: Record<string, unknown>, expected: string[]): boolean {
  const actual = Object.keys(row).sort();
  return actual.length === expected.length &&
    actual.every((key, index) => key === expected[index]);
}

function validTimestamp(value: unknown): value is string {
  return typeof value === "string" && Number.isFinite(Date.parse(value));
}

export function encodeCursor(value: CursorValue): string {
  return btoa(JSON.stringify(value)).replaceAll("+", "-").replaceAll("/", "_")
    .replace(/=+$/u, "");
}

export function decodeCursor(value: string): CursorValue {
  if (!/^[A-Za-z0-9_-]{1,512}$/u.test(value)) throw new Error("invalidCursor");
  try {
    const padded = value.replaceAll("-", "+").replaceAll("_", "/") +
      "=".repeat((4 - value.length % 4) % 4);
    const parsed = JSON.parse(atob(padded));
    if (
      typeof parsed !== "object" || parsed === null || Array.isArray(parsed) ||
      !exactKeys(parsed as Record<string, unknown>, [
        "lastMessageAt",
        "sessionId",
        "v",
      ]) ||
      (parsed as Record<string, unknown>).v !== 1 ||
      !validTimestamp((parsed as Record<string, unknown>).lastMessageAt) ||
      !UUID_PATTERN.test(String((parsed as Record<string, unknown>).sessionId))
    ) {
      throw new Error("invalidCursor");
    }
    const cursor = parsed as CursorValue;
    if (encodeCursor(cursor) !== value) throw new Error("invalidCursor");
    return cursor;
  } catch {
    throw new Error("invalidCursor");
  }
}

export function parseListRequest(url: URL): ListRequest {
  const allowed = new Set(["status", "limit", "cursor"]);
  for (const key of url.searchParams.keys()) {
    if (!allowed.has(key) || url.searchParams.getAll(key).length !== 1) {
      throw new Error("invalidRequest");
    }
  }
  const status = url.searchParams.get("status") ?? "active";
  if (!["active", "archived", "all"].includes(status)) {
    throw new Error("invalidStatus");
  }
  const rawLimit = url.searchParams.get("limit") ?? "20";
  if (!/^(?:[1-9]|[1-4][0-9]|50)$/u.test(rawLimit)) {
    throw new Error("invalidRequest");
  }
  const rawCursor = url.searchParams.get("cursor");
  return {
    status: status as StatusFilter,
    limit: Number(rawLimit),
    cursor: rawCursor === null ? undefined : decodeCursor(rawCursor),
  };
}

function parseSessions(rows: unknown): InternalSession[] {
  if (!Array.isArray(rows)) throw new Error("contractViolation");
  return rows.map((value) => {
    if (
      typeof value !== "object" || value === null || Array.isArray(value) ||
      !exactKeys(value as Record<string, unknown>, SESSION_KEYS)
    ) throw new Error("contractViolation");
    const row = value as Record<string, unknown>;
    if (
      !UUID_PATTERN.test(String(row.conversation_id)) ||
      !UUID_PATTERN.test(String(row.selectable_specialist_id)) ||
      typeof row.specialist_display_name !== "string" ||
      row.specialist_display_name.length === 0 ||
      typeof row.product_area !== "string" || row.product_area.length === 0 ||
      !validTimestamp(row.created_at) ||
      !validTimestamp(row.updated_at) ||
      !["active", "archived"].includes(String(row.status)) ||
      (row.status === "active" && row.archived_at !== null) ||
      (row.status === "archived" && !validTimestamp(row.archived_at)) ||
      !Number.isInteger(row.message_count) ||
      Number(row.message_count) < 0
    ) throw new Error("contractViolation");
    return {
      id: row.conversation_id as string,
      selectableSpecialistId: row.selectable_specialist_id as string,
      specialistDisplayName: row.specialist_display_name as string,
      productArea: row.product_area as string,
      createdAt: row.created_at,
      updatedAt: row.updated_at,
      status: row.status as "active" | "archived",
      messageCount: row.message_count as number,
    };
  });
}

export function buildListResponse(
  sessionRows: unknown,
  limit: number,
): { items: PublicSession[]; nextCursor: string | null } {
  const sessions = parseSessions(sessionRows);
  if (sessions.length > limit + 1) throw new Error("contractViolation");
  const page = sessions.slice(0, limit);
  const items = page.map((session) => {
    return {
      sessionId: session.id,
      selectableSpecialist: {
        id: session.selectableSpecialistId,
        displayName: session.specialistDisplayName,
        area: session.productArea,
      },
      startedAt: session.createdAt,
      lastMessageAt: session.updatedAt,
      status: session.status,
      messageCount: session.messageCount,
    };
  });
  const last = page.at(-1);
  return {
    items,
    nextCursor: sessions.length > limit && last
      ? encodeCursor({
        v: 1,
        lastMessageAt: last.updatedAt,
        sessionId: last.id,
      })
      : null,
  };
}
