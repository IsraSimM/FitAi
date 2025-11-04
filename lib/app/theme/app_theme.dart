import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_colors.dart';
import '../state/app_settings_controller.dart';

/// Modela los temas claro y oscuro de la aplicación.
class AppTheme {
  const AppTheme({required this.light, required this.dark});

  final ThemeData light;
  final ThemeData dark;
}

/// Proveedor global que construye los temas siguiendo el design system descrito en la documentación.
final appThemeProvider = Provider<AppTheme>((ref) {
  final baseLight = ThemeData(
    brightness: Brightness.light,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryLight,
      primary: AppColors.primaryLight,
      secondary: AppColors.secondaryLight,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: AppColors.backgroundLight,
    textTheme: AppTextThemes.light,
  );

  final baseDark = ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primaryDark,
      primary: AppColors.primaryDark,
      secondary: AppColors.secondaryDark,
      brightness: Brightness.dark,
    ),
    scaffoldBackgroundColor: AppColors.backgroundDark,
    textTheme: AppTextThemes.dark,
  );

  return AppTheme(light: baseLight, dark: baseDark);
});

/// Retorna el tema efectivo acorde a las preferencias del usuario.
final effectiveThemeProvider = Provider<AppTheme>((ref) {
  final base = ref.watch(appThemeProvider);
  final settings = ref.watch(appSettingsControllerProvider);

  if (settings.themeChoice == ThemeChoice.custom) {
    final light = base.light.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.customLightColor,
        primary: settings.customLightColor,
        secondary: settings.customDarkColor,
        brightness: Brightness.light,
      ),
    );

    final dark = base.dark.copyWith(
      colorScheme: ColorScheme.fromSeed(
        seedColor: settings.customDarkColor,
        primary: settings.customDarkColor,
        secondary: settings.customLightColor,
        brightness: Brightness.dark,
      ),
    );

    return AppTheme(light: light, dark: dark);
  }

  return base;
});

/// Tipografías personalizadas coherentes con el design system.
class AppTextThemes {
  AppTextThemes._();

  static TextTheme get light => _base.copyWith(
        displayLarge: _base.displayLarge?.copyWith(fontFamily: 'Poppins'),
        displayMedium: _base.displayMedium?.copyWith(fontFamily: 'Poppins'),
        headlineMedium: _base.headlineMedium?.copyWith(fontFamily: 'Poppins'),
      );

  static TextTheme get dark => light;

  static const TextTheme _base = TextTheme(
    displayLarge: TextStyle(fontWeight: FontWeight.w600),
    displayMedium: TextStyle(fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(fontWeight: FontWeight.w600),
    bodyLarge: TextStyle(fontFamily: 'Inter'),
    bodyMedium: TextStyle(fontFamily: 'Inter'),
    bodySmall: TextStyle(fontFamily: 'Inter'),
    labelLarge: TextStyle(fontFamily: 'Inter'),
  );
}
