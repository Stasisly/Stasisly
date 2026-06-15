import 'package:stasisly/features/specialists/domain/entities/selectable_specialist.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

class DemoSelectableSpecialistsRepository
    implements SelectableSpecialistsRepository {
  const DemoSelectableSpecialistsRepository();

  static const _items = [
    SelectableSpecialist(
      id: 'demo-stasis',
      displayName: 'Stasis',
      area: SelectableSpecialistArea.stasis,
      shortDescription: 'Coordina una demostración transparente del catálogo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
      isDemo: true,
    ),
    SelectableSpecialist(
      id: 'demo-health-general',
      displayName: 'Salud general',
      area: SelectableSpecialistArea.health,
      shortDescription:
          'Muestra orientación general de bienestar en modo demo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
      isDemo: true,
    ),
    SelectableSpecialist(
      id: 'demo-nutrition',
      displayName: 'Nutrición',
      area: SelectableSpecialistArea.nutrition,
      shortDescription: 'Presenta hábitos alimentarios ficticios de ejemplo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
      isDemo: true,
    ),
    SelectableSpecialist(
      id: 'demo-training',
      displayName: 'Entrenamiento',
      area: SelectableSpecialistArea.training,
      shortDescription: 'Presenta ejemplos ficticios de actividad cotidiana.',
      accessState: SelectableSpecialistAccessState.demoOnly,
      isDemo: true,
    ),
    SelectableSpecialist(
      id: 'demo-wellness',
      displayName: 'Wellness',
      area: SelectableSpecialistArea.wellness,
      shortDescription: 'Explora rutinas generales de bienestar en modo demo.',
      accessState: SelectableSpecialistAccessState.demoOnly,
      isDemo: true,
    ),
    SelectableSpecialist(
      id: 'demo-sleep-stress',
      displayName: 'Sueño y estrés',
      area: SelectableSpecialistArea.wellness,
      shortDescription: 'Muestra ejemplos ficticios de descanso y equilibrio.',
      accessState: SelectableSpecialistAccessState.demoOnly,
      isDemo: true,
    ),
  ];

  @override
  Future<SelectableSpecialistsResult> listSelectableSpecialists({
    SelectableSpecialistArea? areaFilter,
  }) async {
    final items = areaFilter == null
        ? _items
        : _items.where((item) => item.area == areaFilter).toList();
    if (items.isEmpty) return const SelectableSpecialistsEmpty();
    return SelectableSpecialistsDemo(List.unmodifiable(items));
  }
}
