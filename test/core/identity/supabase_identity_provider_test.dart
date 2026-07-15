import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:stasisly/core/identity/domain/authentication_error.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/authentication_token_result.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/infrastructure/supabase_identity_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

void main() {
  final user = supabase.User.fromJson({
    'id': 'subject-1',
    'email': 'user@example.test',
    'aud': 'authenticated',
    'created_at': '2026-01-01T00:00:00Z',
    'app_metadata': <String, dynamic>{'role': 'admin'},
    'user_metadata': <String, dynamic>{'entitlement': 'vip'},
  })!;

  test('provider user maps without role or entitlement inference', () {
    final identity = SupabaseIdentityMapper.identityFromSupabase(user);

    expect(identity.subjectId, 'subject-1');
    expect(identity.identityType, IdentityType.humanUser);
    expect(identity.authenticationState, AuthenticationState.authenticated);
    expect(identity.email, 'user@example.test');
  });

  test('null provider session maps to explicit unauthenticated state', () {
    final session = SupabaseIdentityMapper.sessionFromSupabase(null);

    expect(session.state, AuthenticationState.unauthenticated);
    expect(session.identity, isNull);
  });

  test('provider session maps without exposing provider object or token', () {
    final providerSession = supabase.Session(
      accessToken: 'synthetic-runtime-credential',
      tokenType: 'bearer',
      user: user,
    );

    final session = SupabaseIdentityMapper.sessionFromSupabase(providerSession);
    final token = SupabaseIdentityMapper.tokenFromSupabase(providerSession);

    expect(session.isAuthenticated, isTrue);
    expect(session.identity?.subjectId, 'subject-1');
    expect(session.toString(), isNot(contains('synthetic-runtime-credential')));
    expect(token.status, AuthenticationTokenStatus.available);
    expect(token.token, 'synthetic-runtime-credential');
    expect(token.toString(), isNot(contains('synthetic-runtime-credential')));
  });

  test('expired provider session remains expired and never authenticates', () {
    final providerSession = supabase.Session(
      accessToken: _tokenWithExpiration(1),
      tokenType: 'bearer',
      user: user,
    );

    final session = SupabaseIdentityMapper.sessionFromSupabase(providerSession);
    final token = SupabaseIdentityMapper.tokenFromSupabase(providerSession);

    expect(session.state, AuthenticationState.expired);
    expect(session.isAuthenticated, isFalse);
    expect(token.status, AuthenticationTokenStatus.expired);
  });

  test('provider errors map to stable sanitized errors', () {
    expect(
      SupabaseAuthenticationErrorMapper.fromException(
        const supabase.AuthException(
          'Provider detail that must not escape',
          code: 'invalid_credentials',
        ),
      ),
      const AuthenticationError(AuthenticationErrorCode.invalidCredentials),
    );
    expect(
      SupabaseAuthenticationErrorMapper.fromException(
        const supabase.AuthException(
          'Private provider detail',
          code: 'unexpected_provider_code',
        ),
      ),
      const AuthenticationError(AuthenticationErrorCode.providerFailure),
    );
  });
}

String _tokenWithExpiration(int expiresAt) {
  String encode(Object value) {
    return base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  }

  return '${encode({'alg': 'none'})}.${encode({'exp': expiresAt})}.';
}
