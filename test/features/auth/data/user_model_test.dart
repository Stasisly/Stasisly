import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:stasisly/core/domain/entities/current_identity.dart';
import 'package:stasisly/features/auth/data/models/user_model.dart';

void main() {
  test('Supabase user metadata cannot grant a role or change identity', () {
    final supabaseUser = supabase.User.fromJson({
      'id': 'auth-user-id',
      'email': 'user@example.test',
      'aud': 'authenticated',
      'created_at': '2026-06-11T00:00:00Z',
      'app_metadata': <String, dynamic>{},
      'user_metadata': <String, dynamic>{
        'role': 'admin',
        'display_name': 'Untrusted name',
      },
    })!;

    final model = UserModel.fromSupabase(supabaseUser);

    expect(model.id, 'auth-user-id');
    expect(model.email, 'user@example.test');
    expect(model.source, IdentitySource.authenticated);
  });
}
