import 'package:flutter/material.dart';
import 'package:pikiva/core/design/app_tokens.dart';

abstract final class AppTheme {
  static ThemeData get light => _build(Brightness.light);
  static ThemeData get dark => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final colors = ColorScheme.fromSeed(
      seedColor: AppColors.seed,
      brightness: brightness,
      surface: brightness == Brightness.light
          ? AppColors.lightSurface
          : AppColors.darkSurface,
    );
    final base = ThemeData(
      useMaterial3: true,
      colorScheme: colors,
      visualDensity: VisualDensity.standard,
      materialTapTargetSize: MaterialTapTargetSize.padded,
    );
    return base.copyWith(
      scaffoldBackgroundColor: colors.surface,
      textTheme: base.textTheme.copyWith(
        headlineLarge: AppTypography.heading.copyWith(color: colors.onSurface),
        titleLarge: AppTypography.title.copyWith(color: colors.onSurface),
        bodyLarge: AppTypography.body.copyWith(color: colors.onSurface),
        bodyMedium: AppTypography.caption.copyWith(
          color: colors.onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        centerTitle: false,
        backgroundColor: colors.surface,
        foregroundColor: colors.onSurface,
        elevation: AppElevation.flat,
        scrolledUnderElevation: AppElevation.flat,
      ),
      cardTheme: CardThemeData(
        elevation: AppElevation.flat,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(
            AppLayout.minimumTouchTarget,
            AppLayout.minimumTouchTarget,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.md,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadii.control),
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          minimumSize: const Size(
            AppLayout.minimumTouchTarget,
            AppLayout.minimumTouchTarget,
          ),
        ),
      ),
      iconTheme: IconThemeData(
        size: AppIconSize.standard,
        color: colors.onSurface,
      ),
    );
  }
}
