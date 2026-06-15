const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
const SESSION_KEYS = [
  "id",
  "last_message_at",
  "message_count",
  "specialist_id",
  "started_at",
  "status",
  "user_id",
].sort();
const CATALOG_KEYS = [
  "display_name",
  "id",
  "is_published",
  "product_area",
  "specialist_id",
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
  userId: string;
  specialistId: string;
  startedAt: string;
  lastMessageAt: string;
  status: "active" | "archived";
  messageCount: number;
}

interface PublicCatalogEntry {
  id: string;
  specialistId: string;
  displayName: string;
  area: string;
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

function parseSessions(rows: unknown, ownerId: string): InternalSession[] {
  if (!Array.isArray(rows)) throw new Error("contractViolation");
  return rows.map((value) => {
    if (
      typeof value !== "object" || value === null || Array.isArray(value) ||
      !exactKeys(value as Record<string, unknown>, SESSION_KEYS)
    ) throw new Error("contractViolation");
    const row = value as Record<string, unknown>;
    if (
      !UUID_PATTERN.test(String(row.id)) ||
      row.user_id !== ownerId ||
      !UUID_PATTERN.test(String(row.specialist_id)) ||
      !validTimestamp(row.started_at) ||
      !validTimestamp(row.last_message_at) ||
      !["active", "archived"].includes(String(row.status)) ||
      !Number.isInteger(row.message_count) ||
      Number(row.message_count) < 0
    ) throw new Error("contractViolation");
    return {
      id: row.id as string,
      userId: row.user_id as string,
      specialistId: row.specialist_id as string,
      startedAt: row.started_at,
      lastMessageAt: row.last_message_at,
      status: row.status as "active" | "archived",
      messageCount: row.message_count as number,
    };
  });
}

function parseCatalog(rows: unknown): Map<string, PublicCatalogEntry> {
  if (!Array.isArray(rows)) throw new Error("contractViolation");
  const entries = new Map<string, PublicCatalogEntry>();
  for (const value of rows) {
    if (
      typeof value !== "object" || value === null || Array.isArray(value) ||
      !exactKeys(value as Record<string, unknown>, CATALOG_KEYS)
    ) throw new Error("contractViolation");
    const row = value as Record<string, unknown>;
    if (
      !UUID_PATTERN.test(String(row.id)) ||
      !UUID_PATTERN.test(String(row.specialist_id)) ||
      row.is_published !== true ||
      typeof row.display_name !== "string" || row.display_name.length === 0 ||
      typeof row.product_area !== "string" || row.product_area.length === 0 ||
      entries.has(row.specialist_id as string)
    ) throw new Error("contractViolation");
    entries.set(row.specialist_id as string, {
      id: row.id as string,
      specialistId: row.specialist_id as string,
      displayName: row.display_name,
      area: row.product_area,
    });
  }
  return entries;
}

export function buildListResponse(
  sessionRows: unknown,
  catalogRows: unknown,
  ownerId: string,
  limit: number,
): { items: PublicSession[]; nextCursor: string | null } {
  const sessions = parseSessions(sessionRows, ownerId);
  if (sessions.length > limit + 1) throw new Error("contractViolation");
  const page = sessions.slice(0, limit);
  const catalog = parseCatalog(catalogRows);
  const items = page.map((session) => {
    const entry = catalog.get(session.specialistId);
    if (!entry) throw new Error("contractViolation");
    return {
      sessionId: session.id,
      selectableSpecialist: {
        id: entry.id,
        displayName: entry.displayName,
        area: entry.area,
      },
      startedAt: session.startedAt,
      lastMessageAt: session.lastMessageAt,
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
        lastMessageAt: last.lastMessageAt,
        sessionId: last.id,
      })
      : null,
  };
}

export function internalSpecialistIds(sessionRows: unknown): string[] {
  if (!Array.isArray(sessionRows)) throw new Error("contractViolation");
  const values = sessionRows.map((row) => {
    if (
      typeof row !== "object" || row === null || Array.isArray(row) ||
      typeof (row as Record<string, unknown>).specialist_id !== "string"
    ) throw new Error("contractViolation");
    return (row as Record<string, string>).specialist_id;
  });
  return [...new Set(values)];
}
