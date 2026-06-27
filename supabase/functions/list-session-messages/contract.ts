const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

const SESSION_KEYS = ["id", "status", "user_id"].sort();
const MESSAGE_KEYS = ["content", "created_at", "id", "role", "session_id"]
  .sort();
const ALLOWED_QUERY_KEYS = new Set(["cursor", "limit", "sessionId"]);
const ALLOWED_ROLES = new Set(["user", "assistant", "system", "tool"]);

export interface CursorValue {
  v: 1;
  createdAt: string;
  messageId: string;
}

export interface ListMessagesRequest {
  sessionId: string;
  limit: number;
  cursor?: CursorValue;
}

export interface PublicMessage {
  messageId: string;
  sessionId: string;
  role: "user" | "assistant" | "system" | "tool";
  content: string;
  createdAt: string;
}

export interface PublicListMessagesResponse {
  items: PublicMessage[];
  nextCursor: string | null;
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
        "createdAt",
        "messageId",
        "v",
      ]) ||
      (parsed as Record<string, unknown>).v !== 1 ||
      !validTimestamp((parsed as Record<string, unknown>).createdAt) ||
      !UUID_PATTERN.test(String((parsed as Record<string, unknown>).messageId))
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

export function parseListMessagesRequest(url: URL): ListMessagesRequest {
  for (const key of url.searchParams.keys()) {
    if (
      !ALLOWED_QUERY_KEYS.has(key) || url.searchParams.getAll(key).length !== 1
    ) {
      throw new Error("invalidRequest");
    }
  }
  const sessionId = url.searchParams.get("sessionId");
  if (!sessionId || !UUID_PATTERN.test(sessionId)) {
    throw new Error("invalidRequest");
  }
  const rawLimit = url.searchParams.get("limit") ?? "50";
  if (!/^(?:[1-9]|[1-9][0-9]|100)$/u.test(rawLimit)) {
    throw new Error("invalidRequest");
  }
  const rawCursor = url.searchParams.get("cursor");
  return {
    sessionId,
    limit: Number(rawLimit),
    cursor: rawCursor === null ? undefined : decodeCursor(rawCursor),
  };
}

export function assertOwnedSession(
  rows: unknown,
  ownerId: string,
  sessionId: string,
): void {
  if (!Array.isArray(rows)) throw new Error("contractViolation");
  if (rows.length === 0) throw new Error("sessionNotFound");
  if (rows.length !== 1) throw new Error("contractViolation");
  const value = rows[0];
  if (typeof value !== "object" || value === null || Array.isArray(value)) {
    throw new Error("contractViolation");
  }
  const row = value as Record<string, unknown>;
  if (
    !exactKeys(row, SESSION_KEYS) ||
    row.id !== sessionId ||
    row.user_id !== ownerId ||
    !["active", "archived"].includes(String(row.status))
  ) {
    throw new Error("contractViolation");
  }
}

export function buildMessagesResponse(
  rows: unknown,
  limit: number,
): PublicListMessagesResponse {
  if (!Array.isArray(rows) || rows.length > limit + 1) {
    throw new Error("contractViolation");
  }
  const page = rows.slice(0, limit).map((value) => {
    if (
      typeof value !== "object" || value === null || Array.isArray(value) ||
      !exactKeys(value as Record<string, unknown>, MESSAGE_KEYS)
    ) {
      throw new Error("contractViolation");
    }
    const row = value as Record<string, unknown>;
    if (
      !UUID_PATTERN.test(String(row.id)) ||
      !UUID_PATTERN.test(String(row.session_id)) ||
      typeof row.role !== "string" ||
      !ALLOWED_ROLES.has(row.role) ||
      typeof row.content !== "string" ||
      row.content.length === 0 ||
      !validTimestamp(row.created_at)
    ) {
      throw new Error("contractViolation");
    }
    return {
      messageId: row.id as string,
      sessionId: row.session_id as string,
      role: row.role as PublicMessage["role"],
      content: row.content as string,
      createdAt: row.created_at as string,
    };
  });
  const last = page.at(-1);
  return {
    items: page,
    nextCursor: rows.length > limit && last
      ? encodeCursor({
        v: 1,
        createdAt: last.createdAt,
        messageId: last.messageId,
      })
      : null,
  };
}
