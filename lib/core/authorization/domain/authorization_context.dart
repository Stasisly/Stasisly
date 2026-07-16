import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_action.dart';
import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_resource.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/domain/delegation_context.dart';
import 'package:stasisly/core/authorization/domain/elevation_context.dart';
import 'package:stasisly/core/authorization/domain/entitlement_context.dart';
import 'package:stasisly/core/authorization/domain/ownership_context.dart';
import 'package:stasisly/core/authorization/domain/purpose_context.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

class AuthorizationContext extends Equatable {
  AuthorizationContext({
    required String correlationId,
    this.identity,
    this.action,
    this.resource,
    this.surface,
    this.environment,
    this.ownership = const OwnershipContext.unknown(),
    this.entitlement = const EntitlementContext.unknown(),
    PurposeContext? purpose,
    this.delegation = const DelegationContext.none(),
    this.elevation = const ElevationContext.none(),
  }) : correlationId = _required(correlationId),
       purpose = purpose ?? PurposeContext(AuthorizationPurpose.unknown);

  final StasislyIdentity? identity;
  final AuthorizationAction? action;
  final AuthorizationResource? resource;
  final AuthorizationSurface? surface;
  final AuthorizationEnvironment? environment;
  final OwnershipContext ownership;
  final EntitlementContext entitlement;
  final PurposeContext purpose;
  final DelegationContext delegation;
  final ElevationContext elevation;
  final String correlationId;

  @override
  List<Object?> get props => [
    identity,
    action,
    resource,
    surface,
    environment,
    ownership,
    entitlement,
    purpose,
    delegation,
    elevation,
    correlationId,
  ];
}

String _required(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) {
    throw ArgumentError.value(value, 'correlationId');
  }
  return normalized;
}
