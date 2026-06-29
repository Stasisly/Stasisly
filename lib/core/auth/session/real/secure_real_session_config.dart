import 'package:equatable/equatable.dart';

enum SecureRealSessionRuntime { demo, backendReal, production }

class SecureRealSessionConfig extends Equatable {
  const SecureRealSessionConfig({
    required this.runtime,
    this.backendActivationApproved = false,
    this.productionActivationApproved = false,
    this.hasRequiredBackendConfiguration = false,
  });

  final SecureRealSessionRuntime runtime;
  final bool backendActivationApproved;
  final bool productionActivationApproved;
  final bool hasRequiredBackendConfiguration;

  bool get isProduction => runtime == SecureRealSessionRuntime.production;

  bool get usesBackend => runtime != SecureRealSessionRuntime.demo;

  @override
  List<Object?> get props => [
    runtime,
    backendActivationApproved,
    productionActivationApproved,
    hasRequiredBackendConfiguration,
  ];
}
