import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/features/auth/domain/entities/user_profile.dart';

void main() {
  test('profile is associated with identity without permissions', () {
    const profile = UserProfile(
      userId: 'user-id',
      displayName: 'Demo profile',
      avatarUrl: 'https://example.invalid/avatar.png',
    );

    expect(profile.userId, 'user-id');
    expect(profile.displayName, 'Demo profile');
  });
}
