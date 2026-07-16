import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/domain/resource_sensitivity.dart';

enum AuthorizationResourceType {
  profile,
  chatSession,
  chatMessage,
  specialistCatalog,
  identity,
  session,
  memory,
  research,
  agent,
  tool,
  configuration,
  audit,
  unknown,
}

enum OwnerReferenceSource { trustedBackend, approvedWorkflow }

class TrustedOwnerReference extends Equatable {
  TrustedOwnerReference.fromTrustedBoundary({
    required String subjectId,
    required this.source,
  }) : subjectId = _required(subjectId, 'subjectId');

  final String subjectId;
  final OwnerReferenceSource source;

  @override
  List<Object?> get props => [subjectId, source];
}

class AuthorizationResource extends Equatable {
  AuthorizationResource({
    required this.type,
    required this.sensitivity,
    required this.surface,
    String? resourceId,
    this.owner,
  }) : resourceId = _optional(resourceId);

  final AuthorizationResourceType type;
  final String? resourceId;
  final TrustedOwnerReference? owner;
  final ResourceSensitivity sensitivity;
  final AuthorizationSurface surface;

  @override
  List<Object?> get props => [type, resourceId, owner, sensitivity, surface];
}

String _required(String value, String name) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(value, name, '$name must not be empty.');
  }
  return normalized;
}

String? _optional(String? value) {
  final normalized = value?.trim();
  return normalized == null || normalized.isEmpty ? null : normalized;
}
