import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stasisly/core/identity/domain/authentication_error.dart';
import 'package:stasisly/core/identity/domain/authentication_result.dart';
import 'package:stasisly/core/identity/domain/authentication_state.dart';
import 'package:stasisly/core/identity/domain/authentication_token_result.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';
import 'package:stasisly/core/identity/ports/identity_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class SupabaseIdentityProvider implements IdentityProvider {
  const SupabaseIdentityProvider(this._client);

  final supabase.SupabaseClient _client;

  @override
  Future<StasislySession> readCurrentSession() async {
    try {
      return SupabaseIdentityMapper.sessionFromSupabase(
        _client.auth.currentSession,
      );
    } on Object {
      return const StasislySession.unavailable();
    }
  }

  @override
  Stream<StasislySession> observeAuthentication() async* {
    try {
      await for (final event in _client.auth.onAuthStateChange) {
        yield SupabaseIdentityMapper.sessionFromSupabase(event.session);
      }
    } on Object {
      yield const StasislySession.unavailable();
    }
  }

  @override
  Future<AuthenticationResult> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final session = SupabaseIdentityMapper.sessionFromSupabase(
        response.session,
      );
      if (!session.isAuthenticated) {
        return const AuthenticationResult.failure(
          AuthenticationError(
            AuthenticationErrorCode.invalidAuthenticationState,
          ),
        );
      }
      return AuthenticationResult.success(session);
    } on supabase.AuthException catch (error) {
      return AuthenticationResult.failure(
        SupabaseAuthenticationErrorMapper.fromException(error),
      );
    } on Object {
      return const AuthenticationResult.failure(
        AuthenticationError(AuthenticationErrorCode.providerFailure),
      );
    }
  }

  @override
  Future<AuthenticationResult> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
      );
      final session = SupabaseIdentityMapper.sessionFromSupabase(
        response.session,
      );
      if (session.isAuthenticated) {
        return AuthenticationResult.success(session);
      }
      if (response.user != null) {
        return const AuthenticationResult.success(
          StasislySession.unauthenticated(),
        );
      }
      return const AuthenticationResult.failure(
        AuthenticationError(AuthenticationErrorCode.invalidAuthenticationState),
      );
    } on supabase.AuthException catch (error) {
      return AuthenticationResult.failure(
        SupabaseAuthenticationErrorMapper.fromException(error),
      );
    } on Object {
      return const AuthenticationResult.failure(
        AuthenticationError(AuthenticationErrorCode.providerFailure),
      );
    }
  }

  @override
  Future<AuthenticationResult> signOut() async {
    try {
      await _client.auth.signOut();
      return const AuthenticationResult.success(
        StasislySession.unauthenticated(),
      );
    } on supabase.AuthException catch (error) {
      return AuthenticationResult.failure(
        SupabaseAuthenticationErrorMapper.fromException(error),
      );
    } on Object {
      return const AuthenticationResult.failure(
        AuthenticationError(AuthenticationErrorCode.providerFailure),
      );
    }
  }

  @override
  Future<AuthenticationResult> refreshSession() async {
    try {
      final response = await _client.auth.refreshSession();
      final session = SupabaseIdentityMapper.sessionFromSupabase(
        response.session,
      );
      if (!session.isAuthenticated) {
        return const AuthenticationResult.failure(
          AuthenticationError(AuthenticationErrorCode.sessionExpired),
        );
      }
      return AuthenticationResult.success(session);
    } on supabase.AuthException catch (error) {
      return AuthenticationResult.failure(
        SupabaseAuthenticationErrorMapper.fromException(error),
      );
    } on Object {
      return const AuthenticationResult.failure(
        AuthenticationError(AuthenticationErrorCode.providerFailure),
      );
    }
  }

  @override
  Future<AuthenticationTokenResult> acquireAccessToken() async {
    try {
      return SupabaseIdentityMapper.tokenFromSupabase(
        _client.auth.currentSession,
      );
    } on Object {
      return const AuthenticationTokenResult.providerFailure();
    }
  }
}

final supabaseIdentityProviderAdapterProvider = Provider<IdentityProvider>((
  ref,
) {
  return SupabaseIdentityProvider(supabase.Supabase.instance.client);
});

abstract final class SupabaseIdentityMapper {
  static StasislyIdentity identityFromSupabase(
    supabase.User user, {
    AuthenticationState state = AuthenticationState.authenticated,
  }) {
    final subjectId = user.id.trim();
    if (subjectId.isEmpty) {
      throw const FormatException('Provider identity has no subject.');
    }
    final email = user.email?.trim();
    return StasislyIdentity(
      subjectId: subjectId,
      identityType: IdentityType.humanUser,
      authenticationState: state,
      email: email == null || email.isEmpty ? null : email,
    );
  }

  static StasislySession sessionFromSupabase(supabase.Session? session) {
    if (session == null) return const StasislySession.unauthenticated();

    final expiresAt = _expiresAt(session);
    if (session.isExpired) {
      return StasislySession.expired(
        identity: identityFromSupabase(
          session.user,
          state: AuthenticationState.expired,
        ),
      );
    }

    return StasislySession.authenticated(
      identity: identityFromSupabase(session.user),
      issuedAt: _parseDate(session.user.lastSignInAt),
      expiresAt: expiresAt,
    );
  }

  static AuthenticationTokenResult tokenFromSupabase(
    supabase.Session? session,
  ) {
    if (session == null) {
      return const AuthenticationTokenResult.unavailable();
    }
    if (session.isExpired) {
      return const AuthenticationTokenResult.expired();
    }
    return AuthenticationTokenResult.available(
      session.accessToken,
      expiresAt: _expiresAt(session),
    );
  }

  static DateTime? _expiresAt(supabase.Session session) {
    final value = session.expiresAt;
    return value == null
        ? null
        : DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
  }

  static DateTime? _parseDate(String? value) {
    return value == null ? null : DateTime.tryParse(value)?.toUtc();
  }
}

abstract final class SupabaseAuthenticationErrorMapper {
  static AuthenticationError fromException(supabase.AuthException error) {
    return switch (error.code) {
      'invalid_credentials' || 'email_not_confirmed' =>
        const AuthenticationError(AuthenticationErrorCode.invalidCredentials),
      'refresh_token_not_found' || 'refresh_token_already_used' =>
        const AuthenticationError(AuthenticationErrorCode.sessionRevoked),
      'session_expired' => const AuthenticationError(
        AuthenticationErrorCode.sessionExpired,
      ),
      'session_not_found' => const AuthenticationError(
        AuthenticationErrorCode.unauthenticated,
      ),
      _ => const AuthenticationError(AuthenticationErrorCode.providerFailure),
    };
  }
}
