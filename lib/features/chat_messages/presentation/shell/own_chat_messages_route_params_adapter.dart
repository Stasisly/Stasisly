class OwnChatMessagesRouteParamsAdapter {
  const OwnChatMessagesRouteParamsAdapter();

  String? sessionIdFrom(Map<String, String> params) {
    final value = params['sessionId']?.trim();
    if (value == null || value.isEmpty) return null;
    if (value.contains('/') || value.contains(r'\')) return null;
    return value;
  }
}
