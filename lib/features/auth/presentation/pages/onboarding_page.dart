import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/core/theme/app_typography.dart';

/// Onboarding / Welcome screen shown to unauthenticated users.
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0D0D1A),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: AppSpacing.pagePadding,
            child: Column(
              children: [
                const Spacer(flex: 2),

                // Logo / Icon
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.primary,
                        AppColors.primaryLight,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.4),
                        blurRadius: 40,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.spa_rounded,
                    size: 56,
                    color: Colors.white,
                  ),
                ),

                const SizedBox(height: AppSpacing.huge),

                // Title
                Text(
                  'Stasisly',
                  style: AppTypography.displayLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -1,
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Subtitle
                Text(
                  'Tu plataforma integral de bienestar\ngestionada por inteligencia artificial',
                  style: AppTypography.bodyLarge.copyWith(
                    color: AppColors.textSecondaryDark,
                    height: 1.6,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.huge),

                // Feature pills
                const _FeaturePill(
                  icon: Icons.favorite_rounded,
                  label: 'Salud personalizada',
                  color: AppColors.healthAccent,
                ),
                const SizedBox(height: AppSpacing.sm),
                const _FeaturePill(
                  icon: Icons.restaurant_rounded,
                  label: 'Nutrición inteligente',
                  color: AppColors.nutritionAccent,
                ),
                const SizedBox(height: AppSpacing.sm),
                const _FeaturePill(
                  icon: Icons.fitness_center_rounded,
                  label: 'Entrenamiento físico adaptativo',
                  color: AppColors.physicalAccent,
                ),
                const SizedBox(height: AppSpacing.sm),
                const _FeaturePill(
                  icon: Icons.psychology_rounded,
                  label: 'Entrenamiento mental guiado',
                  color: AppColors.mentalAccent,
                ),

                const Spacer(flex: 3),

                // CTA Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () => context.go('/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppSpacing.radiusXl),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Comenzar',
                      style: AppTypography.titleMedium.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.md),

                // Secondary link
                TextButton(
                  onPressed: () => context.go('/login'),
                  child: Text(
                    'Ya tengo una cuenta',
                    style: AppTypography.bodyMedium.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  const _FeaturePill({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(
          color: color.withValues(alpha: 0.25),
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: AppSpacing.sm),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
