import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_action.dart';
import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_resource.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/domain/purpose_context.dart';

enum ElevationStatus {
  none,
  standard,
  elevated,
  emergency,
  expired,
  revoked,
  unknown,
}

class ElevationContext extends Equatable {
  const ElevationContext.none() : this._(ElevationStatus.none);

  const ElevationContext.standard() : this._(ElevationStatus.standard);

  const ElevationContext.scoped({
    required this.status,
    required this.actionScope,
    required this.resourceScope,
    required this.surface,
    required this.environment,
    required this.issuedAt,
    required this.expiresAt,
    required this.purpose,
  }) : assert(
         status == ElevationStatus.elevated ||
             status == ElevationStatus.emergency,
         'Scoped elevation must be elevated or emergency.',
       );

  const ElevationContext.expired() : this._(ElevationStatus.expired);

  const ElevationContext.revoked() : this._(ElevationStatus.revoked);

  const ElevationContext.unknown() : this._(ElevationStatus.unknown);

  const ElevationContext._(this.status)
    : actionScope = const {},
      resourceScope = const {},
      surface = null,
      environment = null,
      issuedAt = null,
      expiresAt = null,
      purpose = null;

  final ElevationStatus status;
  final Set<AuthorizationAction> actionScope;
  final Set<AuthorizationResourceType> resourceScope;
  final AuthorizationSurface? surface;
  final AuthorizationEnvironment? environment;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final PurposeContext? purpose;

  bool get isElevated {
    return status == ElevationStatus.elevated ||
        status == ElevationStatus.emergency;
  }

  bool isValidFor({
    required AuthorizationAction action,
    required AuthorizationResourceType resourceType,
    required AuthorizationSurface requestSurface,
    required AuthorizationEnvironment requestEnvironment,
    required DateTime now,
  }) {
    if (status == ElevationStatus.none || status == ElevationStatus.standard) {
      return true;
    }
    if (!isElevated) return false;
    return issuedAt != null &&
        expiresAt != null &&
        purpose != null &&
        purpose!.purpose != AuthorizationPurpose.unknown &&
        !now.isBefore(issuedAt!) &&
        now.isBefore(expiresAt!) &&
        actionScope.contains(action) &&
        resourceScope.contains(resourceType) &&
        surface == requestSurface &&
        environment == requestEnvironment;
  }

  @override
  List<Object?> get props => [
    status,
    actionScope,
    resourceScope,
    surface,
    environment,
    issuedAt,
    expiresAt,
    purpose,
  ];
}
