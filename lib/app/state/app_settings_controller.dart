import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Preferencias globales que impactan tema, idioma y notificaciones.
class AppSettingsState {
  const AppSettingsState({
    required this.themeChoice,
    required this.customLightColor,
    required this.customDarkColor,
    required this.locale,
    required this.notifications,
  });

  factory AppSettingsState.initial() {
    return AppSettingsState(
      themeChoice: ThemeChoice.system,
      customLightColor: Colors.green.shade500,
      customDarkColor: Colors.tealAccent.shade200,
      locale: const Locale('es'),
      notifications: const NotificationPreferences(),
    );
  }

  final ThemeChoice themeChoice;
  final Color customLightColor;
  final Color customDarkColor;
  final Locale locale;
  final NotificationPreferences notifications;

  AppSettingsState copyWith({
    ThemeChoice? themeChoice,
    Color? customLightColor,
    Color? customDarkColor,
    Locale? locale,
    NotificationPreferences? notifications,
  }) {
    return AppSettingsState(
      themeChoice: themeChoice ?? this.themeChoice,
      customLightColor: customLightColor ?? this.customLightColor,
      customDarkColor: customDarkColor ?? this.customDarkColor,
      locale: locale ?? this.locale,
      notifications: notifications ?? this.notifications,
    );
  }
}

/// Opciones de tema disponibles.
enum ThemeChoice { system, light, dark, custom }

/// Configuración por canal de notificación.
class NotificationPreferences {
  const NotificationPreferences({
    this.push = true,
    this.email = false,
    this.inApp = true,
    this.dailyReminders = true,
    this.weeklySummary = true,
    this.personalizedTips = true,
  });

  final bool push;
  final bool email;
  final bool inApp;
  final bool dailyReminders;
  final bool weeklySummary;
  final bool personalizedTips;

  NotificationPreferences copyWith({
    bool? push,
    bool? email,
    bool? inApp,
    bool? dailyReminders,
    bool? weeklySummary,
    bool? personalizedTips,
  }) {
    return NotificationPreferences(
      push: push ?? this.push,
      email: email ?? this.email,
      inApp: inApp ?? this.inApp,
      dailyReminders: dailyReminders ?? this.dailyReminders,
      weeklySummary: weeklySummary ?? this.weeklySummary,
      personalizedTips: personalizedTips ?? this.personalizedTips,
    );
  }
}

class AppSettingsController extends StateNotifier<AppSettingsState> {
  AppSettingsController() : super(AppSettingsState.initial());

  void changeTheme(ThemeChoice choice) {
    state = state.copyWith(themeChoice: choice);
  }

  void updateCustomColors({Color? light, Color? dark}) {
    state = state.copyWith(
      customLightColor: light ?? state.customLightColor,
      customDarkColor: dark ?? state.customDarkColor,
      themeChoice: ThemeChoice.custom,
    );
  }

  void changeLocale(Locale locale) {
    state = state.copyWith(locale: locale);
  }

  void updateNotifications(NotificationPreferences preferences) {
    state = state.copyWith(notifications: preferences);
  }
}

final appSettingsControllerProvider =
    StateNotifierProvider<AppSettingsController, AppSettingsState>((ref) {
  return AppSettingsController();
});

final themeModeProvider = Provider<ThemeMode>((ref) {
  final settings = ref.watch(appSettingsControllerProvider);
  switch (settings.themeChoice) {
    case ThemeChoice.light:
      return ThemeMode.light;
    case ThemeChoice.dark:
      return ThemeMode.dark;
    case ThemeChoice.custom:
      return ThemeMode.light;
    case ThemeChoice.system:
    default:
      return ThemeMode.system;
  }
});

final appLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(appSettingsControllerProvider).locale;
});
