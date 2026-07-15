import 'package:equatable/equatable.dart';

import 'package:stasisly/core/identity/domain/authentication_error.dart';
import 'package:stasisly/core/identity/domain/stasisly_session.dart';

class AuthenticationResult extends Equatable {
  const AuthenticationResult.success(this.session) : error = null;

  const AuthenticationResult.failure(this.error)
    : session = const StasislySession.unavailable();

  final StasislySession session;
  final AuthenticationError? error;

  bool get isSuccess => error == null;

  @override
  List<Object?> get props => [session, error];
}
