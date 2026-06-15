import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:stasisly/features/auth/data/datasources/supabase_auth_datasource.dart';
import 'package:stasisly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stasisly/features/auth/domain/entities/user_entity.dart';
import 'package:stasisly/features/auth/domain/repositories/auth_repository.dart';
import 'package:stasisly/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:stasisly/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:stasisly/features/auth/domain/usecases/sign_up_usecase.dart';

part 'auth_providers.g.dart';

/// Provides the Supabase client instance.
@Riverpod(keepAlive: true)
SupabaseClient supabaseClient(SupabaseClientRef ref) {
  return Supabase.instance.client;
}

/// Provides the SupabaseAuthDataSource.
@Riverpod(keepAlive: true)
SupabaseAuthDataSource authDataSource(AuthDataSourceRef ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseAuthDataSource(supabase);
}

/// Provides the AuthRepository.
@Riverpod(keepAlive: true)
AuthRepository authRepository(AuthRepositoryRef ref) {
  final dataSource = ref.watch(authDataSourceProvider);
  return AuthRepositoryImpl(dataSource);
}

/// Provides the SignInUseCase.
@Riverpod(keepAlive: true)
SignInUseCase signInUseCase(SignInUseCaseRef ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignInUseCase(repo);
}

/// Provides the SignUpUseCase.
@Riverpod(keepAlive: true)
SignUpUseCase signUpUseCase(SignUpUseCaseRef ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignUpUseCase(repo);
}

/// Provides the SignOutUseCase.
@Riverpod(keepAlive: true)
SignOutUseCase signOutUseCase(SignOutUseCaseRef ref) {
  final repo = ref.watch(authRepositoryProvider);
  return SignOutUseCase(repo);
}

/// Manages the current authenticated user state.
/// Listens to auth state changes from Supabase.
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Stream<UserEntity?> build() {
    final repo = ref.watch(authRepositoryProvider);
    return repo.authStateChanges;
  }

  /// Attempts to sign in. Returns true if successful, throws on failure.
  Future<bool> signIn(String email, String password) async {
    final useCase = ref.read(signInUseCaseProvider);
    final result = await useCase(email: email, password: password);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (user) => true,
    );
  }

  /// Attempts to sign up. Returns true if successful, throws on failure.
  Future<bool> signUp(String email, String password) async {
    final useCase = ref.read(signUpUseCaseProvider);
    final result = await useCase(email: email, password: password);

    return result.fold(
      (failure) => throw Exception(failure.message),
      (user) => true,
    );
  }

  /// Signs out the current user.
  Future<void> signOut() async {
    final useCase = ref.read(signOutUseCaseProvider);
    await useCase();
  }
}
