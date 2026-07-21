import 'package:stasisly/features/conversations/domain/value_objects/conversation_id.dart';

class ConversationRouteParamsAdapter {
  const ConversationRouteParamsAdapter();

  ConversationId? conversationIdFrom(Map<String, String> pathParameters) {
    if (pathParameters.keys.any((key) => key != 'conversationId')) return null;
    final value = pathParameters['conversationId'];
    return value == null ? null : ConversationId.tryParse(value);
  }
}
