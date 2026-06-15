import 'package:equatable/equatable.dart';

import 'package:stasisly/features/profile/domain/entities/own_profile.dart';

sealed class OwnProfileResult extends Equatable {
  const OwnProfileResult();

  @override
  List<Object?> get props => [];
}

final class OwnProfileSuccess extends OwnProfileResult {
  const OwnProfileSuccess(this.profile);

  final OwnProfile profile;

  @override
  List<Object?> get props => [profile];
}

final class OwnProfileMissing extends OwnProfileResult {
  const OwnProfileMissing();
}

final class OwnProfileUnauthenticated extends OwnProfileResult {
  const OwnProfileUnauthenticated();
}

final class OwnProfilePermissionDenied extends OwnProfileResult {
  const OwnProfilePermissionDenied();
}

final class OwnProfileBackendBlocked extends OwnProfileResult {
  const OwnProfileBackendBlocked();
}

final class OwnProfileNetworkError extends OwnProfileResult {
  const OwnProfileNetworkError();
}

final class OwnProfileContractViolation extends OwnProfileResult {
  const OwnProfileContractViolation();
}

final class OwnProfileUnexpectedError extends OwnProfileResult {
  const OwnProfileUnexpectedError();
}

sealed class UpdateOwnDisplayNameResult extends Equatable {
  const UpdateOwnDisplayNameResult();

  @override
  List<Object?> get props => [];
}

final class UpdateOwnDisplayNameSuccess extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameSuccess(this.profile);

  final OwnProfile profile;

  @override
  List<Object?> get props => [profile];
}

final class UpdateOwnDisplayNameInvalid extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameInvalid(this.reason);

  final DisplayNameInvalidReason reason;

  @override
  List<Object?> get props => [reason];
}

final class UpdateOwnDisplayNameProfileMissing
    extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameProfileMissing();
}

final class UpdateOwnDisplayNameUnconfirmed extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameUnconfirmed();
}

final class UpdateOwnDisplayNameUnauthenticated
    extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameUnauthenticated();
}

final class UpdateOwnDisplayNamePermissionDenied
    extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNamePermissionDenied();
}

final class UpdateOwnDisplayNameBackendBlocked
    extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameBackendBlocked();
}

final class UpdateOwnDisplayNameNetworkError
    extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameNetworkError();
}

final class UpdateOwnDisplayNameContractViolation
    extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameContractViolation();
}

final class UpdateOwnDisplayNameUnexpectedError
    extends UpdateOwnDisplayNameResult {
  const UpdateOwnDisplayNameUnexpectedError();
}

enum DisplayNameInvalidReason {
  empty,
  tooShort,
  tooLong,
  lineBreak,
  controlCharacter,
}
