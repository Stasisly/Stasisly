import 'package:stasisly/core/auth/session/real/secure_real_session_snapshot.dart';

abstract interface class SecureRealSessionSource {
  Future<SecureRealSessionSnapshot> readCurrentSession();

  Future<SecureRealSessionSnapshot> refreshSession();

  Future<void> clearSession();
}
