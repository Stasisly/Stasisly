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

  test('removed legacy chat cannot define a parallel identity source', () {
    expect(Directory('lib/features/chat').existsSync(), isFalse);
  });
}
