import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/application/secure_session_controller.dart';
import 'package:stasisly/core/auth/session/application/secure_session_state.dart';
import 'package:stasisly/core/auth/session/secure_session_token_provider.dart';
import 'package:stasisly/core/config/app_environment.dart';

final demoSecureSessionTokenProvider = Provider<SecureSessionTokenProvider>((
  ref,
) {
  return const DemoSecureSessionTokenProvider();
});

final backendBlockedSecureSessionTokenProvider =
    Provider<SecureSessionTokenProvider>((ref) {
      return const BackendBlockedSecureSessionTokenProvider();
    });

final unauthenticatedSecureSessionTokenProvider =
    Provider<SecureSessionTokenProvider>((ref) {
      return const UnauthenticatedSecureSessionTokenProvider();
    });

final secureSessionTokenProvider = Provider<SecureSessionTokenProvider>((ref) {
  final environment = ref.watch(appEnvironmentProvider);
  if (environment.isDemo) {
    return ref.watch(demoSecureSessionTokenProvider);
  }

  // ADR-006/ADR-007: backend and production auth remain blocked until a
  // future package wires a reviewed real implementation.
  return ref.watch(backendBlockedSecureSessionTokenProvider);
});

final secureSessionControllerProvider =
    StateNotifierProvider<SecureSessionControllerNotifier, SecureSessionState>((
      ref,
    ) {
      final tokenProvider = ref.watch(secureSessionTokenProvider);
      return SecureSessionControllerNotifier(
        SecureSessionController(tokenProvider: tokenProvider),
      );
    });

final secureSessionStateProvider = Provider<SecureSessionState>((ref) {
  return ref.watch(secureSessionControllerProvider);
});

class SecureSessionControllerNotifier
    extends StateNotifier<SecureSessionState> {
  SecureSessionControllerNotifier(this._controller) : super(_controller.state);

  final SecureSessionController _controller;

  Future<void> checkCurrentSession() async {
    state = state.copyWith(isChecking: true, lastError: null);
    await _controller.checkCurrentSession();
    _syncState();
  }

  Future<void> refreshIfNeeded() async {
    state = state.copyWith(isRefreshing: true, lastError: null);
    await _controller.refreshIfNeeded();
    _syncState();
  }

  Future<void> clearSession() async {
    state = state.copyWith(isClearing: true, lastError: null);
    await _controller.clearSession();
    _syncState();
  }

  bool requireAuthenticated() {
    final result = _controller.requireAuthenticated();
    _syncState();
    return result;
  }

  void _syncState() {
    state = _controller.state;
  }
}
