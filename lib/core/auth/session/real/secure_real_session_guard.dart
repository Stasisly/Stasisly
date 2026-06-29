import 'package:equatable/equatable.dart';

import 'package:stasisly/core/auth/session/real/secure_real_session_config.dart';
import 'package:stasisly/core/auth/session/real/secure_real_session_error.dart';

enum SecureRealSessionGuardStatus {
  allowed,
  backendBlocked,
  productionBlocked,
  misconfigured,
}

class SecureRealSessionGuardDecision extends Equatable {
  const SecureRealSessionGuardDecision._(this.status, this.error);

  const SecureRealSessionGuardDecision.allowed()
    : this._(SecureRealSessionGuardStatus.allowed, null);

  const SecureRealSessionGuardDecision.backendBlocked()
    : this._(
        SecureRealSessionGuardStatus.backendBlocked,
        SecureRealSessionError.backendBlocked,
      );

  const SecureRealSessionGuardDecision.productionBlocked()
    : this._(
        SecureRealSessionGuardStatus.productionBlocked,
        SecureRealSessionError.productionBlocked,
      );

  const SecureRealSessionGuardDecision.misconfigured()
    : this._(
        SecureRealSessionGuardStatus.misconfigured,
        SecureRealSessionError.misconfiguredEnvironment,
      );

  final SecureRealSessionGuardStatus status;
  final SecureRealSessionError? error;

  bool get isAllowed => status == SecureRealSessionGuardStatus.allowed;

  @override
  List<Object?> get props => [status, error];
}

class SecureRealSessionGuard {
  const SecureRealSessionGuard();

  SecureRealSessionGuardDecision evaluate(SecureRealSessionConfig config) {
    if (!config.usesBackend) {
      return const SecureRealSessionGuardDecision.backendBlocked();
    }

    if (!config.hasRequiredBackendConfiguration) {
      return const SecureRealSessionGuardDecision.misconfigured();
    }

    if (config.isProduction && !config.productionActivationApproved) {
      return const SecureRealSessionGuardDecision.productionBlocked();
    }

    if (!config.backendActivationApproved) {
      return const SecureRealSessionGuardDecision.backendBlocked();
    }

    return const SecureRealSessionGuardDecision.allowed();
  }
}
