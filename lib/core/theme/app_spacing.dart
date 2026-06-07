import 'package:flutter/material.dart';

/// Stasisly spacing scale based on a 4px grid.
///
/// Use these constants for padding, margins, gaps, and border radius
/// to maintain visual consistency throughout the app.
abstract final class AppSpacing {
  // ── Spacing (multiples of 4) ───────────────────────────────────────────

  /// 2px — hairline spacing.
  static const double xxs = 2;

  /// 4px — micro spacing.
  static const double xs = 4;

  /// 8px — small spacing.
  static const double sm = 8;

  /// 12px — compact spacing.
  static const double md = 12;

  /// 16px — standard spacing.
  static const double lg = 16;

  /// 20px — comfortable spacing.
  static const double xl = 20;

  /// 24px — spacious.
  static const double xxl = 24;

  /// 32px — section spacing.
  static const double xxxl = 32;

  /// 40px — large section spacing.
  static const double huge = 40;

  /// 48px — extra large.
  static const double massive = 48;

  /// 64px — max spacing.
  static const double gigantic = 64;

  // ── Edge Insets (common patterns) ──────────────────────────────────────

  /// Standard page padding (horizontal 16, vertical 16).
  static const EdgeInsets pagePadding = EdgeInsets.all(lg);

  /// Horizontal page padding only.
  static const EdgeInsets pageHorizontal = EdgeInsets.symmetric(
    horizontal: lg,
  );

  /// Card internal padding.
  static const EdgeInsets cardPadding = EdgeInsets.all(lg);

  /// Compact card padding.
  static const EdgeInsets cardPaddingCompact = EdgeInsets.all(md);

  /// Chat message padding.
  static const EdgeInsets messagePadding = EdgeInsets.symmetric(
    horizontal: md,
    vertical: sm,
  );

  /// Input field content padding.
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: md,
  );

  // ── Border Radius ──────────────────────────────────────────────────────

  /// Small radius — 4px.
  static const double radiusSm = 4;

  /// Medium radius — 8px.
  static const double radiusMd = 8;

  /// Standard radius — 12px.
  static const double radiusLg = 12;

  /// Large radius — 16px.
  static const double radiusXl = 16;

  /// Extra large radius — 24px.
  static const double radiusXxl = 24;

  /// Full/pill radius — 999px.
  static const double radiusFull = 999;

  /// Standard border radius.
  static const BorderRadius borderRadiusMd = BorderRadius.all(
    Radius.circular(radiusMd),
  );

  /// Card border radius.
  static const BorderRadius borderRadiusLg = BorderRadius.all(
    Radius.circular(radiusLg),
  );

  /// Sheet/modal border radius.
  static const BorderRadius borderRadiusXl = BorderRadius.all(
    Radius.circular(radiusXl),
  );

  /// Pill shape border radius.
  static const BorderRadius borderRadiusFull = BorderRadius.all(
    Radius.circular(radiusFull),
  );

  // ── Sizing ─────────────────────────────────────────────────────────────

  /// Avatar size — small (32px).
  static const double avatarSm = 32;

  /// Avatar size — medium (40px).
  static const double avatarMd = 40;

  /// Avatar size — large (56px).
  static const double avatarLg = 56;

  /// Avatar size — extra large (80px).
  static const double avatarXl = 80;

  /// Icon size — small (16px).
  static const double iconSm = 16;

  /// Icon size — medium (20px).
  static const double iconMd = 20;

  /// Icon size — standard (24px).
  static const double iconLg = 24;

  /// Icon size — large (32px).
  static const double iconXl = 32;

  /// Bottom nav bar height.
  static const double bottomNavHeight = 72;

  /// App bar height.
  static const double appBarHeight = 56;

  /// Max content width for web.
  static const double maxContentWidth = 600;

  /// Max dashboard width for web.
  static const double maxDashboardWidth = 1200;
}
