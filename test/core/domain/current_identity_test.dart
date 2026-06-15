import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/core/domain/entities/current_identity.dart';

void main() {
  test('demo identity is explicit and centralized', () {
    const identity = CurrentIdentity.demo();

    expect(identity.id, CurrentIdentity.demoId);
    expect(identity.source, IdentitySource.demo);
    expect(identity.isDemo, isTrue);
    expect(identity.email, isNull);
  });

  test('authenticated identity contract contains identity only', () {
    const identity = CurrentIdentity.authenticated(
      id: 'auth-user-id',
      email: 'user@example.test',
    );

    expect(identity.id, 'auth-user-id');
    expect(identity.source, IdentitySource.authenticated);
    expect(identity.isDemo, isFalse);
  });
}
