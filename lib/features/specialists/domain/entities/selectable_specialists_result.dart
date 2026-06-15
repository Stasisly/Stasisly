import 'package:equatable/equatable.dart';

import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

sealed class SelectableSpecialistsResult extends Equatable {
  const SelectableSpecialistsResult();

  @override
  List<Object?> get props => [];
}

final class SelectableSpecialistsSuccess extends SelectableSpecialistsResult {
  const SelectableSpecialistsSuccess(this.specialists);

  final List<SelectableSpecialist> specialists;

  @override
  List<Object?> get props => [specialists];
}

final class SelectableSpecialistsEmpty extends SelectableSpecialistsResult {
  const SelectableSpecialistsEmpty();
}

final class SelectableSpecialistsDemo extends SelectableSpecialistsResult {
  const SelectableSpecialistsDemo(this.specialists);

  final List<SelectableSpecialist> specialists;

  @override
  List<Object?> get props => [specialists];
}

final class SelectableSpecialistsBackendBlocked
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsBackendBlocked();
}

final class SelectableSpecialistsUnauthenticated
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsUnauthenticated();
}

final class SelectableSpecialistsPermissionDenied
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsPermissionDenied();
}

final class SelectableSpecialistsInvalidSession
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsInvalidSession();
}

final class SelectableSpecialistsInvalidArea
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsInvalidArea();
}

final class SelectableSpecialistsContractViolation
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsContractViolation();
}

final class SelectableSpecialistsNetworkError
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsNetworkError();
}

final class SelectableSpecialistsUnexpectedError
    extends SelectableSpecialistsResult {
  const SelectableSpecialistsUnexpectedError();
}
