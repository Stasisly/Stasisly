export interface SafeLogEvent {
  operation: "archiveOwnChatSession";
  result: "success" | "error";
  latency: number;
  contract_version: "1";
  request_id: string;
}

export type LogWriter = (serializedEvent: string) => void;

export function safeLog(event: SafeLogEvent, writer: LogWriter): void {
  writer(JSON.stringify(event));
}
