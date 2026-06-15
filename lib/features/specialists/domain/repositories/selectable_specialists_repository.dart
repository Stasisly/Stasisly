import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';

// The abstraction is intentional: demo, blocked and future adapters share it.
// ignore: one_member_abstracts
abstract class SelectableSpecialistsRepository {
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  });
}
