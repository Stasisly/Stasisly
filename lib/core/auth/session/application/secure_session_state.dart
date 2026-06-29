import 'package:equatable/equatable.dart';

import 'package:stasisly/core/auth/session/secure_session_auth_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_result.dart';

class SecureSessionState extends Equatable {
  const SecureSessionState({
    this.authState = const SecureSessionAuthState.unauthenticated(),
    this.isChecking = false,
    this.isRefreshing = false,
    this.isClearing = false,
    this.lastError,
  });

  final SecureSessionAuthState authState;
  final bool isChecking;
  final bool isRefreshing;
  final bool isClearing;
  final SecureSessionError? lastError;

  bool get isDemo => authState.status == SecureSessionAuthStatus.demo;

  bool get isAuthenticated {
    return authState.status == SecureSessionAuthStatus.authenticated;
  }

  bool get isUnauthenticated {
    return authState.status == SecureSessionAuthStatus.unauthenticated;
  }

  bool get isBackendBlocked {
    return authState.status == SecureSessionAuthStatus.backendBlocked;
  }

  bool get isMisconfigured {
    return authState.status == SecureSessionAuthStatus.misconfigured;
  }

  bool get isExpired => authState.status == SecureSessionAuthStatus.expired;

  bool get isRefreshFailed {
    return authState.status == SecureSessionAuthStatus.refreshFailed;
  }

  bool get hasActiveWork => isChecking || isRefreshing || isClearing;

  SecureSessionState copyWith({
    SecureSessionAuthState? authState,
    bool? isChecking,
    bool? isRefreshing,
    bool? isClearing,
    Object? lastError = _sentinel,
  }) {
    return SecureSessionState(
      authState: authState ?? this.authState,
      isChecking: isChecking ?? this.isChecking,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isClearing: isClearing ?? this.isClearing,
      lastError: identical(lastError, _sentinel)
          ? this.lastError
          : lastError as SecureSessionError?,
    );
  }

  @override
  List<Object?> get props => [
    authState,
    isChecking,
    isRefreshing,
    isClearing,
    lastError,
  ];
}

const Object _sentinel = Object();
