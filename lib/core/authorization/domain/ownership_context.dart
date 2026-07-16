import 'package:equatable/equatable.dart';

import 'package:stasisly/core/authorization/domain/authorization_resource.dart';
import 'package:stasisly/core/identity/domain/stasisly_identity.dart';

enum OwnershipStatus {
  owned,
  notOwned,
  shared,
  delegated,
  systemOwned,
  notApplicable,
  unknown,
}

class OwnershipContext extends Equatable {
  const OwnershipContext._(this.status, this.source);

  factory OwnershipContext.fromTrustedResource({
    required StasislyIdentity identity,
    required AuthorizationResource resource,
  }) {
    final owner = resource.owner;
    if (owner == null) return const OwnershipContext.unknown();
    return OwnershipContext._(
      owner.subjectId == identity.subjectId
          ? OwnershipStatus.owned
          : OwnershipStatus.notOwned,
      owner.source,
    );
  }

  const OwnershipContext.shared() : this._(OwnershipStatus.shared, null);

  const OwnershipContext.delegated() : this._(OwnershipStatus.delegated, null);

  const OwnershipContext.systemOwned()
    : this._(OwnershipStatus.systemOwned, null);

  const OwnershipContext.notApplicable()
    : this._(OwnershipStatus.notApplicable, null);

  const OwnershipContext.unknown() : this._(OwnershipStatus.unknown, null);

  final OwnershipStatus status;
  final OwnerReferenceSource? source;

  @override
  List<Object?> get props => [status, source];
}
