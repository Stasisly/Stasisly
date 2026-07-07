// The interface keeps host policy injection explicit in repository tests.
// ignore: one_member_abstracts
abstract interface class OwnChatMessagesHostPolicy {
  bool allows(Uri baseUri);
}

class LocalOnlyHostPolicy implements OwnChatMessagesHostPolicy {
  const LocalOnlyHostPolicy({required this.localValidationEnabled});

  final bool localValidationEnabled;

  @override
  bool allows(Uri baseUri) {
    if (!localValidationEnabled ||
        baseUri.scheme != 'http' ||
        !baseUri.hasPort ||
        baseUri.userInfo.isNotEmpty ||
        baseUri.hasQuery ||
        baseUri.hasFragment ||
        baseUri.path != '' && baseUri.path != '/') {
      return false;
    }
    return baseUri.host == 'localhost' || baseUri.host == '127.0.0.1';
  }
}

class DevelopmentRemoteHostPolicy implements OwnChatMessagesHostPolicy {
  const DevelopmentRemoteHostPolicy({
    required this.enabled,
    required this.approvedHost,
  });

  final bool enabled;
  final String approvedHost;

  @override
  bool allows(Uri baseUri) {
    final host = approvedHost.trim().toLowerCase();
    if (!enabled ||
        host.isEmpty ||
        baseUri.scheme != 'https' ||
        baseUri.userInfo.isNotEmpty ||
        baseUri.hasQuery ||
        baseUri.hasFragment ||
        baseUri.hasPort ||
        baseUri.path != '' && baseUri.path != '/') {
      return false;
    }
    final baseHost = baseUri.host.toLowerCase();
    return baseHost == host && baseHost.endsWith('.supabase.co');
  }
}
