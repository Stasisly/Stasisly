import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/app.dart';
import 'package:stasisly/core/config/app_environment.dart';
import 'package:stasisly/features/health/presentation/pages/health_page.dart';

void main() {
  testWidgets('app starts in explicit demo mode', (tester) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appEnvironmentProvider.overrideWithValue(
            const AppEnvironment(mode: AppRuntimeMode.demo),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('MODO DEMO · DATOS FICTICIOS'), findsOneWidget);
    expect(
      find.text('Esta capacidad no está disponible en este entorno.'),
      findsOneWidget,
    );
  });

  testWidgets('demo does not fall through to a protected Product route', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appEnvironmentProvider.overrideWithValue(
            const AppEnvironment(mode: AppRuntimeMode.demo),
          ),
        ],
        child: const App(),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Esta capacidad no está disponible en este entorno.'),
      findsOneWidget,
    );
    expect(find.byType(HealthPage), findsNothing);
    expect(find.text('MODO DEMO · DATOS FICTICIOS'), findsOneWidget);
  });
}
