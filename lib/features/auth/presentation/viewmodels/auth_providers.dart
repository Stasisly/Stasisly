import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/identity/domain/authentication_error.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';
import 'package:stasisly/core/identity/providers/identity_providers.dart';
import 'package:stasisly/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:stasisly/features/auth/domain/repositories/auth_repository.dart';
import 'package:stasisly/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:stasisly/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:stasisly/features/auth/domain/usecases/sign_up_usecase.dart';

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.watch(identityProviderProvider));
});

final signInUseCaseProvider = Provider<SignInUseCase>((ref) {
  return SignInUseCase(ref.watch(authRepositoryProvider));
});

final signUpUseCaseProvider = Provider<SignUpUseCase>((ref) {
  return SignUpUseCase(ref.watch(authRepositoryProvider));
});

final signOutUseCaseProvider = Provider<SignOutUseCase>((ref) {
  return SignOutUseCase(ref.watch(authRepositoryProvider));
});

final authControllerProvider =
    StreamNotifierProvider<AuthController, StasislySession>(AuthController.new);

class AuthController extends StreamNotifier<StasislySession> {
  @override
  Stream<StasislySession> build() {
    return ref.watch(authRepositoryProvider).observeAuthentication();
  }

  Future<bool> signIn(String email, String password) async {
    final result = await ref.read(signInUseCaseProvider)(
      email: email,
      password: password,
    );
    if (!result.isSuccess) {
      throw StasislyAuthenticationException(result.error!);
    }
    return true;
  }

  Future<bool> signUp(String email, String password) async {
    final result = await ref.read(signUpUseCaseProvider)(
      email: email,
      password: password,
    );
    if (!result.isSuccess) {
      throw StasislyAuthenticationException(result.error!);
    }
    return true;
  }

  Future<void> signOut() async {
    final result = await ref.read(signOutUseCaseProvider)();
    if (!result.isSuccess) {
      throw StasislyAuthenticationException(result.error!);
    }
  }
}
