import 'package:equatable/equatable.dart';

enum SelectableSpecialistArea { stasis, health, nutrition, training, wellness }

enum SelectableSpecialistAccessState {
  available,
  lockedPro,
  unavailable,
  demoOnly,
}

/// Minimal catalog item. It carries no prompt, authority or execution data.
class SelectableSpecialist extends Equatable {
  const SelectableSpecialist({
    required this.selectableSpecialistId,
    required this.displayName,
    required this.publicArea,
    required this.publicDescription,
    required this.accessState,
  });

  final String selectableSpecialistId;
  final String displayName;
  final SelectableSpecialistArea publicArea;
  final String publicDescription;
  final SelectableSpecialistAccessState accessState;

  @override
  List<Object?> get props => [
    selectableSpecialistId,
    displayName,
    publicArea,
    publicDescription,
    accessState,
  ];
}
