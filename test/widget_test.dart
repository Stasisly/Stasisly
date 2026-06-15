import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:stasisly/app.dart';
import 'package:stasisly/core/config/app_environment.dart';

void main() {
  testWidgets('app starts in explicit demo mode', (tester) async {
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
    expect(find.text('Stasis'), findsWidgets);
  });

  testWidgets('demo navigation reaches health route', (tester) async {
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

    await tester.tap(find.text('Salud'));
    await tester.pumpAndSettle();

    expect(find.text('Salud'), findsWidgets);
    expect(find.text('MODO DEMO · DATOS FICTICIOS'), findsOneWidget);
  });
}
