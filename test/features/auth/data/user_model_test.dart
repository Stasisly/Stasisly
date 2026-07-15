import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/identity/identity.dart';
import 'package:stasisly/features/auth/data/models/user_model.dart';

void main() {
  test('legacy model cannot add authority to canonical identity', () {
    const identity = StasislyIdentity(
      subjectId: 'auth-user-id',
      identityType: IdentityType.humanUser,
      authenticationState: AuthenticationState.authenticated,
      email: 'user@example.test',
    );

    final model = UserModel.fromIdentity(identity);

    expect(model.id, 'auth-user-id');
    expect(model.email, 'user@example.test');
    expect(model.authenticationState, AuthenticationState.authenticated);
  });
}
