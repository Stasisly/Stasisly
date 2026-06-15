import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('auth mapping and registration do not use metadata roles', () {
    final userModel = File(
      'lib/features/auth/data/models/user_model.dart',
    ).readAsStringSync();
    final authDataSource = File(
      'lib/features/auth/data/datasources/supabase_auth_datasource.dart',
    ).readAsStringSync();

    expect(userModel, isNot(contains('userMetadata')));
    expect(userModel, isNot(contains("metadata['role']")));
    expect(authDataSource, isNot(contains("'role':")));
  });

  test('chat consumes central identity without a local demo id', () {
    final chatProviders = File(
      'lib/features/chat/presentation/viewmodels/chat_providers.dart',
    ).readAsStringSync();

    expect(chatProviders, contains('currentIdentityProvider'));
    expect(chatProviders, isNot(contains('demo-user')));
    expect(chatProviders, isNot(contains('chatUserIdProvider')));
  });
}
