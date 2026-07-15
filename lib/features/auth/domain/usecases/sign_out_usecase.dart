import 'package:stasisly/core/identity/domain/authentication_result.dart';
import 'package:stasisly/features/auth/domain/repositories/auth_repository.dart';

class SignOutUseCase {
  const SignOutUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthenticationResult> call() {
    return _repository.signOut();
  }
}
