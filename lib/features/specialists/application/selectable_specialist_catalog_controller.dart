import 'package:stasisly/features/specialists/application/selectable_specialist_catalog_state.dart';
import 'package:stasisly/features/specialists/domain/entities/selectable_specialists_result.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

class SelectableSpecialistCatalogController {
  SelectableSpecialistCatalogController({
    required SelectableSpecialistCatalog catalog,
    void Function(SelectableSpecialistCatalogState)? onStateChanged,
  }) : _catalog = catalog,
       _onStateChanged = onStateChanged;

  final SelectableSpecialistCatalog _catalog;
  final void Function(SelectableSpecialistCatalogState)? _onStateChanged;
  bool _disposed = false;

  SelectableSpecialistCatalogState state =
      const SelectableSpecialistCatalogState();

  Future<void> load() async {
    if (_disposed || state.phase == SelectableSpecialistCatalogPhase.loading) {
      return;
    }
    _emit(
      SelectableSpecialistCatalogState(
        phase: SelectableSpecialistCatalogPhase.loading,
        items: state.items,
      ),
    );
    final result = await _catalog.listSelectableSpecialists();
    if (_disposed) return;
    switch (result) {
      case SelectableSpecialistsSuccess(:final specialists):
        _emit(
          SelectableSpecialistCatalogState(
            phase: SelectableSpecialistCatalogPhase.data,
            items: List.unmodifiable(specialists),
          ),
        );
      case SelectableSpecialistsEmpty():
        _emit(
          const SelectableSpecialistCatalogState(
            phase: SelectableSpecialistCatalogPhase.empty,
          ),
        );
      case SelectableSpecialistsUnauthenticated():
        _emit(
          const SelectableSpecialistCatalogState(
            phase: SelectableSpecialistCatalogPhase.unauthenticated,
          ),
        );
      case SelectableSpecialistsBackendBlocked():
        _emit(
          const SelectableSpecialistCatalogState(
            phase: SelectableSpecialistCatalogPhase.environmentBlocked,
          ),
        );
      default:
        _emit(
          const SelectableSpecialistCatalogState(
            phase: SelectableSpecialistCatalogPhase.error,
          ),
        );
    }
  }

  void _emit(SelectableSpecialistCatalogState next) {
    if (_disposed) return;
    state = next;
    _onStateChanged?.call(next);
  }

  void dispose() => _disposed = true;
}
