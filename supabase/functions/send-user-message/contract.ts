const UUID_PATTERN =
  /^[0-9a-f]{8}-[0-9a-f]{4}-[1-5][0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$/i;

const REQUEST_KEYS = ["content", "sessionId"].sort();
const RPC_KEYS = [
  "content",
  "created_at",
  "idempotent_replay",
  "message_id",
  "role",
  "session_id",
  "session_last_message_at",
  "session_message_count",
].sort();

export interface SendMessageCommand {
  sessionId: string;
  content: string;
}

export interface PublicSendMessageResponse {
  message: {
    messageId: string;
    sessionId: string;
    role: "user";
    content: string;
    createdAt: string;
  };
  session: {
    sessionId: string;
    messageCount: number;
    lastMessageAt: string;
  };
}

export interface SanitizedSendMessage {
  payload: PublicSendMessageResponse;
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

export async function parseSendMessageBody(
  request: Request,
): Promise<SendMessageCommand> {
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
  const keys = Object.keys(record).sort();
  if (
    keys.length !== REQUEST_KEYS.length ||
    keys.some((key, index) => key !== REQUEST_KEYS[index])
  ) {
    throw new Error("invalidRequest");
  }
  if (
    typeof record.sessionId !== "string" ||
    !UUID_PATTERN.test(record.sessionId)
  ) {
    throw new Error("invalidRequest");
  }
  if (typeof record.content !== "string") throw new Error("contentInvalid");
  const content = record.content.trim();
  if (content.length === 0) throw new Error("contentInvalid");
  if (content.length > 4000) throw new Error("contentTooLong");
  return { sessionId: record.sessionId, content };
}

export function sanitizeRpcResult(rows: unknown): SanitizedSendMessage {
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
    typeof row.message_id !== "string" ||
    !UUID_PATTERN.test(row.message_id) ||
    typeof row.session_id !== "string" ||
    !UUID_PATTERN.test(row.session_id) ||
    row.role !== "user" ||
    typeof row.content !== "string" ||
    row.content.length === 0 ||
    typeof row.created_at !== "string" ||
    typeof row.session_last_message_at !== "string" ||
    typeof row.session_message_count !== "number" ||
    typeof row.idempotent_replay !== "boolean"
  ) {
    throw new Error("contractViolation");
  }
  return {
    payload: {
      message: {
        messageId: row.message_id,
        sessionId: row.session_id,
        role: "user",
        content: row.content,
        createdAt: row.created_at,
      },
      session: {
        sessionId: row.session_id,
        messageCount: row.session_message_count,
        lastMessageAt: row.session_last_message_at,
      },
    },
    idempotentReplay: row.idempotent_replay,
  };
}
