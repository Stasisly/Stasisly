import 'package:dartz/dartz.dart';

import 'package:stasisly/core/error/failures.dart';
import 'package:stasisly/features/auth/domain/entities/user_entity.dart';
import 'package:stasisly/features/auth/domain/repositories/auth_repository.dart';

class SignUpUseCase {
  const SignUpUseCase(this._repository);

  final AuthRepository _repository;

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    String? displayName,
  }) {
    return _repository.signUpWithEmail(
      email: email,
      password: password,
      displayName: displayName,
    );
  }
}
