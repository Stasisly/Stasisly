import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:stasisly/core/config/app_config.dart';
import 'package:stasisly/core/config/routes.dart';
import 'package:stasisly/core/theme/app_theme.dart';

/// Main application widget.
class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConfig.appName,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark, // Default to dark theme as requested
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
