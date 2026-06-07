import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/core/theme/app_typography.dart';
import 'package:stasisly/features/orchestrator/presentation/widgets/dashboard_card.dart';

class OrchestratorPage extends ConsumerWidget {
  const OrchestratorPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // In a real scenario, fetch user name from AuthController
    const userName = 'Raúl';

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.lg,
                  vertical: AppSpacing.md,
                ),
                title: Text(
                  'Hola, $userName',
                  style: AppTypography.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.backgroundDark,
                        AppColors.backgroundDark.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SliverPadding(
              padding: AppSpacing.pagePadding,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  // Stasis Banner
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    decoration: BoxDecoration(
                      gradient: AppColors.orchestratorGradient,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.orchestratorAccent.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.smart_toy, color: Colors.white, size: 32),
                            const SizedBox(width: AppSpacing.md),
                            Text(
                              'Stasis',
                              style: AppTypography.titleLarge.copyWith(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.md),
                        Text(
                          'Tu orquestador personal está listo. Hoy tienes 2 tareas pendientes en tu entrenamiento físico y 1 recordatorio de nutrición.',
                          style: AppTypography.bodyMedium.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        ElevatedButton(
                          onPressed: () => context.go('/orchestrator/chat'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.orchestratorAccent,
                          ),
                          child: const Text('Hablar con Stasis'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  Text(
                    'Resumen del día',
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  // Grid of cards
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: AppSpacing.md,
                    crossAxisSpacing: AppSpacing.md,
                    childAspectRatio: 1.1,
                    children: [
                      DashboardCard(
                        title: 'Sueño',
                        icon: Icons.bedtime_rounded,
                        color: AppColors.mentalAccent,
                        value: '7h 20m',
                        subtitle: 'Calidad: 85%',
                        onTap: () => context.go('/mental'),
                      ),
                      DashboardCard(
                        title: 'Calorías',
                        icon: Icons.local_fire_department_rounded,
                        color: AppColors.nutritionAccent,
                        value: '1,850',
                        subtitle: 'Faltan 350 kcal',
                        onTap: () => context.go('/nutrition'),
                      ),
                      DashboardCard(
                        title: 'Actividad',
                        icon: Icons.directions_run_rounded,
                        color: AppColors.physicalAccent,
                        value: '45 min',
                        subtitle: 'Entrenamiento de fuerza',
                        onTap: () => context.go('/physical'),
                      ),
                      DashboardCard(
                        title: 'Próximo',
                        icon: Icons.medical_services_rounded,
                        color: AppColors.healthAccent,
                        value: 'Analítica',
                        subtitle: 'En 3 días',
                        onTap: () => context.go('/health'),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
