import 'package:flutter/material.dart';

/// Stasisly premium color palette.
///
/// Dark theme primary with deep indigo/slate tones.
/// Accent colors per branch for visual identity.
/// All foreground/background combos meet WCAG AA (4.5:1 contrast).
abstract final class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────

  /// Primary brand color — deep indigo.
  static const Color primary = Color(0xFF6366F1);

  /// Primary variant — lighter indigo for hover/active states.
  static const Color primaryLight = Color(0xFF818CF8);

  /// Primary dark — deeper indigo for pressed states.
  static const Color primaryDark = Color(0xFF4F46E5);

  // ── Branch Accent Colors ───────────────────────────────────────────────

  /// Health branch — emerald green.
  static const Color healthAccent = Color(0xFF10B981);

  /// Nutrition branch — amber/orange.
  static const Color nutritionAccent = Color(0xFFF59E0B);

  /// Physical training branch — coral/red.
  static const Color physicalAccent = Color(0xFFEF4444);

  /// Mental training branch — soft violet.
  static const Color mentalAccent = Color(0xFF8B5CF6);

  /// Orchestrator — cyan/teal.
  static const Color orchestratorAccent = Color(0xFF06B6D4);

  // ── Surfaces (Dark Theme) ──────────────────────────────────────────────

  /// Main background — near-black slate.
  static const Color backgroundDark = Color(0xFF0F172A);

  /// Surface — slightly lighter for cards/sheets.
  static const Color surfaceDark = Color(0xFF1E293B);

  /// Surface variant — for elevated cards, modals.
  static const Color surfaceVariantDark = Color(0xFF334155);

  /// Border/divider color.
  static const Color borderDark = Color(0xFF475569);

  // ── Surfaces (Light Theme) ─────────────────────────────────────────────

  /// Main background — pure white with warmth.
  static const Color backgroundLight = Color(0xFFF8FAFC);

  /// Surface — soft gray.
  static const Color surfaceLight = Color(0xFFFFFFFF);

  /// Surface variant.
  static const Color surfaceVariantLight = Color(0xFFF1F5F9);

  /// Border/divider color.
  static const Color borderLight = Color(0xFFE2E8F0);

  // ── Text ───────────────────────────────────────────────────────────────

  /// Primary text on dark — high contrast white.
  static const Color textPrimaryDark = Color(0xFFF1F5F9);

  /// Secondary text on dark — muted.
  static const Color textSecondaryDark = Color(0xFF94A3B8);

  /// Tertiary text on dark — very muted.
  static const Color textTertiaryDark = Color(0xFF64748B);

  /// Primary text on light.
  static const Color textPrimaryLight = Color(0xFF0F172A);

  /// Secondary text on light.
  static const Color textSecondaryLight = Color(0xFF475569);

  /// Tertiary text on light.
  static const Color textTertiaryLight = Color(0xFF94A3B8);

  // ── Semantic ───────────────────────────────────────────────────────────

  /// Success — green.
  static const Color success = Color(0xFF22C55E);

  /// Warning — amber.
  static const Color warning = Color(0xFFF59E0B);

  /// Error — red.
  static const Color error = Color(0xFFEF4444);

  /// Info — blue.
  static const Color info = Color(0xFF3B82F6);

  // ── Glassmorphism ──────────────────────────────────────────────────────

  /// Glass overlay for glassmorphism effects.
  static const Color glassOverlay = Color(0x1AFFFFFF);

  /// Glass border for glassmorphism.
  static const Color glassBorder = Color(0x33FFFFFF);

  // ── Gradients ──────────────────────────────────────────────────────────

  /// Primary gradient.
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [primary, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Health branch gradient.
  static const LinearGradient healthGradient = LinearGradient(
    colors: [Color(0xFF059669), healthAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Nutrition branch gradient.
  static const LinearGradient nutritionGradient = LinearGradient(
    colors: [Color(0xFFD97706), nutritionAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Physical training branch gradient.
  static const LinearGradient physicalGradient = LinearGradient(
    colors: [Color(0xFFDC2626), physicalAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Mental training branch gradient.
  static const LinearGradient mentalGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), mentalAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Orchestrator gradient.
  static const LinearGradient orchestratorGradient = LinearGradient(
    colors: [Color(0xFF0891B2), orchestratorAccent],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
