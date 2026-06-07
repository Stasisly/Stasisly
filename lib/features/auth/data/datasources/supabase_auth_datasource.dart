import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import 'package:stasisly/core/error/exceptions.dart';
import 'package:stasisly/features/auth/data/models/user_model.dart';

/// DataSource for authentication using Supabase.
class SupabaseAuthDataSource {
  const SupabaseAuthDataSource(this._supabase);

  final supabase.SupabaseClient _supabase;

  /// Stream of user state changes.
  Stream<UserModel?> get authStateChanges {
    return _supabase.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return UserModel.fromSupabase(user);
    });
  }

  /// Synchronously gets the current user.
  UserModel? get currentUser {
    final user = _supabase.auth.currentUser;
    if (user == null) return null;
    return UserModel.fromSupabase(user);
  }

  /// Signs in a user with email and password.
  Future<UserModel> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException(message: 'Error al iniciar sesión. Usuario no encontrado.');
      }

      return UserModel.fromSupabase(user);
    } on supabase.AuthException catch (e) {
      throw AuthException(message: e.message); // My Custom Exception
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Registers a new user.
  Future<UserModel> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
        data: {
          if (displayName != null) 'display_name': displayName,
          'role': 'user', // Default role
        },
      );

      final user = response.user;
      if (user == null) {
        throw const AuthException(message: 'Error al registrar. Usuario no creado.');
      }

      return UserModel.fromSupabase(user);
    } on supabase.AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    try {
      await _supabase.auth.signOut();
    } on supabase.AuthException catch (e) {
      throw AuthException(message: e.message);
    } catch (e) {
      throw ServerException(message: e.toString());
    }
  }
}
