/// Supplies an ephemeral token for the approved local validation runtime.
// ignore: one_member_abstracts
abstract interface class LocalSessionTokenProvider {
  Future<String?> readLocalSessionToken();
}
