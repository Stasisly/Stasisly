import 'package:equatable/equatable.dart';

import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';

enum SelectableSpecialistCatalogPhase {
  initial,
  loading,
  data,
  empty,
  unauthenticated,
  environmentBlocked,
  error,
}

class SelectableSpecialistCatalogState extends Equatable {
  const SelectableSpecialistCatalogState({
    this.phase = SelectableSpecialistCatalogPhase.initial,
    this.items = const [],
  });

  final SelectableSpecialistCatalogPhase phase;
  final List<SelectableSpecialist> items;

  @override
  List<Object?> get props => [phase, items];
}
