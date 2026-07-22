import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/auth/session/providers/secure_session_providers.dart';
import 'package:stasisly/core/authorization/domain/authorization_surface.dart';
import 'package:stasisly/core/authorization/infrastructure/app_environment_authorization_mapper.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/core/routing/application/entry_point_boundary_enforcer.dart';
import 'package:stasisly/core/routing/infrastructure/entry_point_registry.dart';
import 'package:stasisly/features/specialists/application/selectable_specialist_catalog_controller.dart';
import 'package:stasisly/features/specialists/application/selectable_specialist_catalog_state.dart';
import 'package:stasisly/features/specialists/data/datasources/http_selectable_specialists_remote_datasource.dart';
import 'package:stasisly/features/specialists/data/repositories/backend_blocked_selectable_specialists_repository.dart';
import 'package:stasisly/features/specialists/data/repositories/selectable_specialists_repository_impl.dart';
import 'package:stasisly/features/specialists/domain/repositories/selectable_specialists_repository.dart';

final selectableSpecialistsRepositoryProvider =
    Provider<SelectableSpecialistsRepository>((ref) {
      final environment = ref.watch(appEnvironmentProvider);
      final session = ref.watch(secureSessionStateProvider);
      final decision = const EntryPointBoundaryEnforcer().evaluate(
        definition: EntryPointRegistry.specialistsCatalog,
        actualSurface: AuthorizationSurface.product,
        actualEnvironment: AppEnvironmentAuthorizationMapper.fromRuntimeMode(
          environment.mode,
        ),
        isAuthenticated: session.isAuthenticated,
        remotePermissionGranted: environment.allowsRemoteSupabase,
      );
      if (!decision.isAllowed) {
        return const BackendBlockedSelectableSpecialistsRepository();
      }

      final baseUri = Uri.tryParse(environment.supabaseUrl);
      if (baseUri == null) {
        return const BackendBlockedSelectableSpecialistsRepository();
      }
      final hostPolicy = environment.isLocal
          ? const LocalSelectableSpecialistsHostPolicy()
          : DevelopmentSelectableSpecialistsHostPolicy(
              enabled: environment.allowsRealAuth,
            );
      return SelectableSpecialistsRepositoryImpl(
        dataSource: HttpSelectableSpecialistsRemoteDataSource(
          baseUri: baseUri,
          hostPolicy: hostPolicy,
          tokenProvider: ref.watch(secureSessionTokenProvider),
        ),
      );
    });

final selectableSpecialistCatalogControllerProvider =
    StateNotifierProvider.autoDispose<
      SelectableSpecialistCatalogControllerNotifier,
      SelectableSpecialistCatalogState
    >((ref) {
      return SelectableSpecialistCatalogControllerNotifier(
        catalog: ref.watch(selectableSpecialistsRepositoryProvider),
      );
    });

class SelectableSpecialistCatalogControllerNotifier
    extends StateNotifier<SelectableSpecialistCatalogState> {
  SelectableSpecialistCatalogControllerNotifier({
    required SelectableSpecialistCatalog catalog,
  }) : super(const SelectableSpecialistCatalogState()) {
    _controller = SelectableSpecialistCatalogController(
      catalog: catalog,
      onStateChanged: (next) => state = next,
    );
  }

  late final SelectableSpecialistCatalogController _controller;

  Future<void> load() => _controller.load();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
