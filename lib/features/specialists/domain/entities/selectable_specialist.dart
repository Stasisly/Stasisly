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
    required this.id,
    required this.displayName,
    required this.area,
    required this.shortDescription,
    required this.accessState,
    required this.isDemo,
  });

  final String id;
  final String displayName;
  final SelectableSpecialistArea area;
  final String shortDescription;
  final SelectableSpecialistAccessState accessState;
  final bool isDemo;

  @override
  List<Object?> get props => [
    id,
    displayName,
    area,
    shortDescription,
    accessState,
    isDemo,
  ];
}
