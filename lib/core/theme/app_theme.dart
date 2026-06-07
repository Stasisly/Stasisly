import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:stasisly/core/theme/app_colors.dart';
import 'package:stasisly/core/theme/app_spacing.dart';
import 'package:stasisly/core/theme/app_typography.dart';

/// Stasisly theme configuration.
///
/// Provides dark (default) and light themes with premium aesthetics,
/// glassmorphism-ready surfaces, and WCAG AA compliant contrasts.
abstract final class AppTheme {
  // ── Dark Theme (Default) ───────────────────────────────────────────────

  static ThemeData get darkTheme {
    final textTheme = AppTypography.buildTextTheme(
      color: AppColors.textPrimaryDark,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: AppColors.backgroundDark,
      textTheme: textTheme,
      colorScheme: const ColorScheme.dark(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryDark,
        secondary: AppColors.orchestratorAccent,
        onSecondary: Colors.white,
        surface: AppColors.surfaceDark,
        onSurface: AppColors.textPrimaryDark,
        surfaceContainerHighest: AppColors.surfaceVariantDark,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderDark,
      ),

      // ── AppBar ────────────────────────────────────────────────────────
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundDark,
        foregroundColor: AppColors.textPrimaryDark,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ── Bottom Navigation ─────────────────────────────────────────────
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceDark,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiaryDark,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
      ),

      // ── Cards ─────────────────────────────────────────────────────────
      cardTheme: const CardThemeData(
        color: AppColors.surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          side: BorderSide(color: AppColors.borderDark, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),

      // ── Elevated Button ───────────────────────────────────────────────
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // ── Outlined Button ───────────────────────────────────────────────
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Text Button ───────────────────────────────────────────────────
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTypography.labelLarge,
        ),
      ),

      // ── Input Decoration ──────────────────────────────────────────────
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantDark,
        contentPadding: AppSpacing.inputPadding,
        border: const OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide(
            color: AppColors.borderDark,
            width: 0.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide(color: AppColors.error),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiaryDark,
        ),
        labelStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textSecondaryDark,
        ),
      ),

      // ── Chip ──────────────────────────────────────────────────────────
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        selectedColor: AppColors.primary.withValues(alpha: 0.2),
        labelStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        side: const BorderSide(color: AppColors.borderDark, width: 0.5),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusFull,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),

      // ── Dialog ────────────────────────────────────────────────────────
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surfaceDark,
        surfaceTintColor: Colors.transparent,
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusXl,
        ),
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryDark,
        ),
      ),

      // ── Divider ───────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.borderDark,
        thickness: 0.5,
        space: 0,
      ),

      // ── Snackbar ──────────────────────────────────────────────────────
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceVariantDark,
        contentTextStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textPrimaryDark,
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ── Light Theme ────────────────────────────────────────────────────────

  static ThemeData get lightTheme {
    final textTheme = AppTypography.buildTextTheme(
      color: AppColors.textPrimaryLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: textTheme,
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: Colors.white,
        primaryContainer: AppColors.primaryLight,
        secondary: AppColors.orchestratorAccent,
        onSecondary: Colors.white,
        surface: AppColors.surfaceLight,
        onSurface: AppColors.textPrimaryLight,
        surfaceContainerHighest: AppColors.surfaceVariantLight,
        error: AppColors.error,
        onError: Colors.white,
        outline: AppColors.borderLight,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.backgroundLight,
        foregroundColor: AppColors.textPrimaryLight,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTypography.titleLarge.copyWith(
          color: AppColors.textPrimaryLight,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textTertiaryLight,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: AppTypography.labelSmall.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelSmall,
      ),
      cardTheme: const CardThemeData(
        color: AppColors.surfaceLight,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          side: BorderSide(color: AppColors.borderLight, width: 0.5),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.md,
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: AppSpacing.borderRadiusFull,
          ),
          textStyle: AppTypography.labelLarge.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceVariantLight,
        contentPadding: AppSpacing.inputPadding,
        border: const OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide.none,
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide(
            color: AppColors.borderLight,
            width: 0.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: AppSpacing.borderRadiusLg,
          borderSide: BorderSide(
            color: AppColors.primary,
            width: 1.5,
          ),
        ),
        hintStyle: AppTypography.bodyMedium.copyWith(
          color: AppColors.textTertiaryLight,
        ),
      ),
    );
  }
}
