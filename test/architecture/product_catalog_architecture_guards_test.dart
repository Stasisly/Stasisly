import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final productCatalogDirectory = Directory('lib/features/specialists');

  Iterable<File> dartFilesUnder(Directory directory) {
    return directory
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));
  }

  test('product catalog has no direct Supabase, secrets or SQL coupling', () {
    final files = dartFilesUnder(productCatalogDirectory).toList();

    expect(files, isNotEmpty);
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'supabase_flutter',
        'Supabase.instance',
        'functions.invoke',
        'from(',
        'rpc(',
        'select=*',
        'SELECT *',
        'service_role',
        'SUPABASE_SERVICE_ROLE_KEY',
        'Authorization:',
        'Bearer ',
        'access_token',
        'refresh_token',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test(
    'product catalog cannot fall back to demo for real backend failures',
    () {
      final repository = File(
        'lib/features/specialists/data/repositories/'
        'selectable_specialists_repository_impl.dart',
      ).readAsStringSync();
      final provider = File(
        'lib/features/specialists/presentation/providers/'
        'selectable_specialists_providers.dart',
      ).readAsStringSync();

      expect(
        repository,
        isNot(contains('DemoSelectableSpecialistsRepository')),
      );
      expect(repository, isNot(contains('SelectableSpecialistsDemo')));
      expect(repository, contains('SelectableSpecialistsNetworkError'));
      expect(repository, contains('SelectableSpecialistsContractViolation'));
      expect(repository, contains('SelectableSpecialistsUnexpectedError'));

      expect(provider, isNot(contains('if (environment.isDemo)')));
      expect(provider, isNot(contains('DemoSelectableSpecialistsRepository')));
      expect(provider, contains('EntryPointBoundaryEnforcer'));
      expect(
        provider,
        contains('BackendBlockedSelectableSpecialistsRepository'),
      );
      expect(provider, isNot(contains('SelectableSpecialistsRepositoryImpl')));
    },
  );

  test('product catalog does not use fixtures or synthetic auth material', () {
    final files = dartFilesUnder(productCatalogDirectory).toList();

    expect(files, isNotEmpty);
    for (final file in files) {
      final source = file.readAsStringSync();
      for (final forbidden in [
        'SYNTHETIC_ACCESS_TOKEN',
        'SYNTHETIC_REFRESH_TOKEN',
        'SYNTHETIC_USER_PASSWORD',
        'DevelopmentSyntheticSecureSessionTokenProvider',
        'secure_real_session_fixtures',
        'fake-local-session-token',
        'fixture',
        'Fixture',
      ]) {
        expect(source, isNot(contains(forbidden)), reason: file.path);
      }
    }
  });

  test('legacy chat routes are not product catalog or session routes', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();
    final registrySource = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();

    expect(registrySource, contains("pathPattern: '/conversations'"));
    expect(
      registrySource,
      contains("pathPattern: '/conversations/:conversationId'"),
    );
    expect(routesSource, isNot(contains("path: '/conversations/:sessionId'")));
    expect(routesSource, isNot(contains("path: '/conversations/:id'")));
    expect(routesSource, isNot(contains("path: '/conversations/:agentId'")));
    expect(routesSource, isNot(contains("path: '/conversation'")));
    expect(registrySource, contains("pathPattern: '/chat/:id'"));
    expect(registrySource, contains("pathPattern: '/orchestrator/chat'"));
    expect(registrySource, contains('EntryPointLegacyState.legacyBlocked'));
    expect(routesSource, isNot(contains('AgentChatWrapper')));
    expect(routesSource, isNot(contains('OrchestratorChatPage')));
  });

  test('dev-only routes are not product routes or catalog entry points', () {
    final routesSource = File('lib/core/config/routes.dart').readAsStringSync();
    final registrySource = File(
      'lib/core/routing/infrastructure/entry_point_registry.dart',
    ).readAsStringSync();
    final devRouteSource = routesSource.substring(
      routesSource.indexOf('List<RouteBase> _developmentChatMessageRoutes'),
    );

    expect(registrySource, contains("pathPattern: '/dev/chat/composed'"));
    expect(
      registrySource,
      contains("pathPattern: '/dev/chat/session/:sessionId'"),
    );
    expect(devRouteSource, contains('if (kReleaseMode) return const []'));
    expect(devRouteSource, isNot(contains('/conversations')));
    expect(devRouteSource, isNot(contains('SelectableSpecialistsRepository')));
    expect(devRouteSource, isNot(contains('SelectableSpecialistModel')));
    expect(devRouteSource, isNot(contains('specialist_catalog')));
    expect(devRouteSource, isNot(contains('SYNTHETIC_ACCESS_TOKEN')));
    expect(devRouteSource, isNot(contains('fixture')));
    expect(devRouteSource, isNot(contains('Fixture')));
    expect(devRouteSource, isNot(contains('Admin/Engine')));
    expect(devRouteSource, isNot(contains('Wizard')));
  });

  test(
    'product catalog cannot import Wizard, development or Admin surfaces',
    () {
      final files = dartFilesUnder(productCatalogDirectory).toList();

      expect(files, isNotEmpty);
      for (final file in files) {
        final source = file.readAsStringSync();
        for (final forbidden in [
          'features/admin',
          'features/orchestrator',
          'orchestrator_chat',
          'OrchestratorPage',
          'AdminDecision',
          'AdminEngine',
          'Admin/Engine',
          'Wizard',
          'Development Surface',
          'Director de Proyecto',
          'Product Owner',
          'Revisor de Coherencia',
          'Arquitecto Principal',
          'AppSec',
          'QA',
          'DevOps',
        ]) {
          expect(source, isNot(contains(forbidden)), reason: file.path);
        }
      }
    },
  );
}
