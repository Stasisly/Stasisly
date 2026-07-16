import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_action.dart';
import 'package:stasisly/core/authorization/domain/authorization_decision.dart';
import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_resource.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/identity/domain/identity_type.dart';

class AuthorizationAuditEvent extends Equatable {
  const AuthorizationAuditEvent({
    required this.subjectId,
    required this.identityType,
    required this.action,
    required this.resourceType,
    required this.surface,
    required this.environment,
    required this.decision,
    required this.reasonCode,
    required this.policyReference,
    required this.correlationId,
    this.entryPointReference,
    this.legacyStateReference,
  });

  final String? subjectId;
  final IdentityType? identityType;
  final AuthorizationAction? action;
  final AuthorizationResourceType? resourceType;
  final AuthorizationSurface? surface;
  final AuthorizationEnvironment? environment;
  final AuthorizationDecisionType decision;
  final AuthorizationReasonCode reasonCode;
  final String policyReference;
  final String correlationId;
  final String? entryPointReference;
  final String? legacyStateReference;

  @override
  List<Object?> get props => [
    subjectId,
    identityType,
    action,
    resourceType,
    surface,
    environment,
    decision,
    reasonCode,
    policyReference,
    correlationId,
    entryPointReference,
    legacyStateReference,
  ];
}
