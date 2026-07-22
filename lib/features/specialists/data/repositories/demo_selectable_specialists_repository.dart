import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

class DemoSelectableSpecialistsRepository
    implements SelectableSpecialistsRepository {
  const DemoSelectableSpecialistsRepository();

  static const _items = [
    SelectableSpecialist(
      selectableSpecialistId: 'demo-stasis',
      displayName: 'Stasis',
      publicArea: SelectableSpecialistArea.stasis,
      publicDescription: 'Coordina una demostración transparente del catálogo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
    ),
    SelectableSpecialist(
      selectableSpecialistId: 'demo-health-general',
      displayName: 'Salud general',
      publicArea: SelectableSpecialistArea.health,
      publicDescription:
          'Muestra orientación general de bienestar en modo demo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
    ),
    SelectableSpecialist(
      selectableSpecialistId: 'demo-nutrition',
      displayName: 'Nutrición',
      publicArea: SelectableSpecialistArea.nutrition,
      publicDescription: 'Presenta hábitos alimentarios ficticios de ejemplo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
    ),
    SelectableSpecialist(
      selectableSpecialistId: 'demo-training',
      displayName: 'Entrenamiento',
      publicArea: SelectableSpecialistArea.training,
      publicDescription: 'Presenta ejemplos ficticios de actividad cotidiana.',
      accessState: SelectableSpecialistAccessState.demoOnly,
    ),
    SelectableSpecialist(
      selectableSpecialistId: 'demo-wellness',
      displayName: 'Wellness',
      publicArea: SelectableSpecialistArea.wellness,
      publicDescription: 'Explora rutinas generales de bienestar en modo demo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
    ),
    SelectableSpecialist(
      selectableSpecialistId: 'demo-sleep-stress',
      displayName: 'Sueño y estrés',
      publicArea: SelectableSpecialistArea.wellness,
      publicDescription: 'Muestra ejemplos ficticios de descanso y equilibrio.',
      accessState: SelectableSpecialistAccessState.demoOnly,
    ),
  ];

  @override
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async {
    final items = areaFilter == null
        ? _items
        : _items.where((item) => item.publicArea == areaFilter).toList();
    if (items.isEmpty) return const SelectableSpecialistsEmpty();
    return SelectableSpecialistsDemo(List.unmodifiable(items));
  }
}
