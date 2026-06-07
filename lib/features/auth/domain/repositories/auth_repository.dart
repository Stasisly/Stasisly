import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/auth/domain/entities/user_entity.dart';

/// Interface for authentication operations.
abstract class AuthRepository {
  /// Stream of authentication state changes.
  /// Emits the current user if logged in, or null if logged out.
  Stream<UserEntity?> get authStateChanges;

  /// Returns the current user if logged in synchronously.
  UserEntity? get currentUser;

  /// Signs in a user with email and password.
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  /// Registers a new user with email and password.
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    String? displayName,
  });

  /// Signs out the current user.
  Future<Either<Failure, void>> signOut();
}
