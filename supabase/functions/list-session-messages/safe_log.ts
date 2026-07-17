export interface SafeLogEvent {
  operation: "conversation.message.listOwn";
  result: "success" | "error";
  latency: number;
  count: number;
  contract_version: "1";
  request_id: string;
  error_code?: string;
}

export type LogWriter = (serializedEvent: string) => void;

export function safeLog(event: SafeLogEvent, writer: LogWriter): void {
  writer(JSON.stringify(event));
}
