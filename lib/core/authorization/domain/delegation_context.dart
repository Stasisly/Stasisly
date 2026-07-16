import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_action.dart';
import 'package:stasisly/core/authorization/domain/authorization_environment.dart';
import 'package:stasisly/core/authorization/domain/authorization_resource.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';

enum DelegationStatus { none, active, expired, revoked, invalid }

class DelegationContext extends Equatable {
  const DelegationContext.none()
    : status = DelegationStatus.none,
      delegatorSubjectId = null,
      delegateSubjectId = null,
      resourceScope = const {},
      actionScope = const {},
      surface = null,
      environment = null,
      issuedAt = null,
      expiresAt = null,
      furtherDelegationAllowed = false;

  DelegationContext.active({
    required String delegatorSubjectId,
    required String delegateSubjectId,
    required this.resourceScope,
    required this.actionScope,
    required this.surface,
    required this.environment,
    required this.issuedAt,
    required this.expiresAt,
    this.furtherDelegationAllowed = false,
  }) : status = DelegationStatus.active,
       delegatorSubjectId = _required(delegatorSubjectId),
       delegateSubjectId = _required(delegateSubjectId);

  const DelegationContext.expired() : this._terminal(DelegationStatus.expired);

  const DelegationContext.revoked() : this._terminal(DelegationStatus.revoked);

  const DelegationContext.invalid() : this._terminal(DelegationStatus.invalid);

  const DelegationContext._terminal(this.status)
    : delegatorSubjectId = null,
      delegateSubjectId = null,
      resourceScope = const {},
      actionScope = const {},
      surface = null,
      environment = null,
      issuedAt = null,
      expiresAt = null,
      furtherDelegationAllowed = false;

  final DelegationStatus status;
  final String? delegatorSubjectId;
  final String? delegateSubjectId;
  final Set<AuthorizationResourceType> resourceScope;
  final Set<AuthorizationAction> actionScope;
  final AuthorizationSurface? surface;
  final AuthorizationEnvironment? environment;
  final DateTime? issuedAt;
  final DateTime? expiresAt;
  final bool furtherDelegationAllowed;

  bool isValidFor({
    required String subjectId,
    required AuthorizationAction action,
    required AuthorizationResourceType resourceType,
    required AuthorizationSurface requestSurface,
    required AuthorizationEnvironment requestEnvironment,
    required DateTime now,
  }) {
    if (status == DelegationStatus.none) return true;
    if (status != DelegationStatus.active) return false;
    return delegateSubjectId == subjectId &&
        issuedAt != null &&
        expiresAt != null &&
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
    delegatorSubjectId,
    delegateSubjectId,
    resourceScope,
    actionScope,
    surface,
    environment,
    issuedAt,
    expiresAt,
    furtherDelegationAllowed,
  ];
}

String _required(String value) {
  final normalized = value.trim();
  if (normalized.isEmpty) throw ArgumentError.value(value, 'subjectId');
  return normalized;
}
