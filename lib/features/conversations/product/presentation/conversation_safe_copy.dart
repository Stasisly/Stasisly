import 'package:stasisly/features/conversations/application/state/conversation_application_states.dart';

String conversationSafeError(
  ConversationApplicationErrorCode? error,
) => switch (error) {
  ConversationApplicationErrorCode.unauthenticated =>
    'Necesitas una sesión válida.',
  ConversationApplicationErrorCode.unauthorized ||
  ConversationApplicationErrorCode.notFound =>
    'La conversación no está disponible.',
  ConversationApplicationErrorCode.environmentBlocked =>
    'Esta capacidad no está disponible en este entorno.',
  ConversationApplicationErrorCode.invalidInput => 'Revisa los datos enviados.',
  ConversationApplicationErrorCode.archived =>
    'No se puede enviar a una conversación archivada.',
  ConversationApplicationErrorCode.idempotencyConflict =>
    'El intento entra en conflicto. Modifica el mensaje antes de continuar.',
  ConversationApplicationErrorCode.backendUnavailable =>
    'El servicio no está disponible. Puedes reintentar.',
  ConversationApplicationErrorCode.contractViolation ||
  ConversationApplicationErrorCode.unknownFailure ||
  null => 'No se pudo completar la operación.',
};
