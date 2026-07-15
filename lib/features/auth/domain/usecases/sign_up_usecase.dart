import 'package:stasisly/core/identity/domain/authentication_result.dart';
import 'package:stasisly/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<AuthenticationResult> call({
    required String email,
    required String password,
  }) {
    return _repository.signUp(email: email, password: password);
  }
}
