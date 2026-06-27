class LocalOnlyHostPolicy {
  const LocalOnlyHostPolicy({required this.localValidationEnabled});

  final bool localValidationEnabled;

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
