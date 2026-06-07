import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/widgets/app_shell.dart';
import 'package:stasisly/features/auth/presentation/pages/login_page.dart';
import 'package:stasisly/features/auth/presentation/pages/onboarding_page.dart';
import 'package:stasisly/features/auth/presentation/pages/register_page.dart';
import 'package:stasisly/features/auth/presentation/viewmodels/auth_providers.dart';
import 'package:stasisly/features/chat/presentation/pages/agent_chat_wrapper.dart';
import 'package:stasisly/features/health/presentation/pages/health_page.dart';
import 'package:stasisly/features/mental_training/presentation/pages/mental_training_page.dart';
import 'package:stasisly/features/nutrition/presentation/pages/nutrition_page.dart';
import 'package:stasisly/features/orchestrator/presentation/pages/orchestrator_chat_page.dart' as stasisly_orchestrator;
import 'package:stasisly/features/orchestrator/presentation/pages/orchestrator_page.dart';
import 'package:stasisly/features/physical_training/presentation/pages/physical_training_page.dart';

/// Provides the GoRouter instance.
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/orchestrator',
    redirect: (context, state) {
      // --- TEMP BYPASS PARA TESTING SPRINT 2 ---
      return null;
      /*
      // Si la autenticación aún está cargando, no hacer nada todavía
      if (authState.isLoading) return null;

      final isAuth = authState.valueOrNull != null;
      final isLoggingIn = state.uri.path == '/login' || state.uri.path == '/register' || state.uri.path == '/onboarding';

      // Si no está autenticado y no está en la página de login, redirigir al login
      if (!isAuth && !isLoggingIn) {
        return '/onboarding';
      }

      // Si está autenticado pero intenta ir al login, redirigir a inicio
      if (isAuth && isLoggingIn) {
        return '/health';
      }

      return null;
      */
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/health',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: HealthPage(),
            ),
          ),
          GoRoute(
            path: '/nutrition',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: NutritionPage(),
            ),
          ),
          GoRoute(
            path: '/physical',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PhysicalTrainingPage(),
            ),
          ),
          GoRoute(
            path: '/mental',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: MentalTrainingPage(),
            ),
          ),
          GoRoute(
            path: '/orchestrator',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: OrchestratorPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/orchestrator/chat',
        builder: (context, state) => const stasisly_orchestrator.OrchestratorChatPage(),
      ),
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return AgentChatWrapper(agentId: id);
        },
      ),
    ],
  );
});
