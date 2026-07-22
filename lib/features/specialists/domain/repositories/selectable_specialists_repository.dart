import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';

/// Product-safe catalog boundary. Implementations must never expose runtime
/// agent identity or internal specialist records.
// ignore: one_member_abstracts
abstract interface class SelectableSpecialistCatalog {
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  });
}

// Kept as the repository-facing name for compatibility with existing adapters.
abstract interface class SelectableSpecialistsRepository
    implements SelectableSpecialistCatalog {}
