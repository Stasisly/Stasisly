import 'package:equatable/equatable.dart';

enum AuthorizationPurpose {
  userRequested,
  serviceOperation,
  support,
  security,
  administration,
  development,
  research,
  emergency,
  notRequired,
  unknown,
}

class PurposeContext extends Equatable {
  PurposeContext(this.purpose, {String? reference})
    : reference = _optional(reference);

  final AuthorizationPurpose purpose;

  /// Non-sensitive correlation detail. It is never policy authority.
  final String? reference;

  @override
  List<Object?> get props => [purpose, reference];
}

String? _optional(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
