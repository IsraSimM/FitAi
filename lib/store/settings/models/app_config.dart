import 'package:flutter/material.dart';
import 'menu_item.dart';

class AppConfig {
  final ThemeMode themeMode;
  final Locale locale;
  final List<MenuItem> menu; // materialized, ordered, enabled-only view

  // Robust flags
  final bool isFirstRun;
  final bool notificationsEnabled;
  final bool telemetryOptIn;
  final bool menuDynamicEnabled;

  // Meta
  final int schemaVersion;
  final String? appVersion; // optional, for diagnostics

  const AppConfig({
    required this.themeMode,
    required this.locale,
    required this.menu,
    required this.isFirstRun,
    required this.notificationsEnabled,
    required this.telemetryOptIn,
    required this.menuDynamicEnabled,
    required this.schemaVersion,
    this.appVersion,
  });

  AppConfig copyWith({
    ThemeMode? themeMode,
    Locale? locale,
    List<MenuItem>? menu,
    bool? isFirstRun,
    bool? notificationsEnabled,
    bool? telemetryOptIn,
    bool? menuDynamicEnabled,
    int? schemaVersion,
    String? appVersion,
  }) => AppConfig(
    themeMode: themeMode ?? this.themeMode,
    locale: locale ?? this.locale,
    menu: menu ?? this.menu,
    isFirstRun: isFirstRun ?? this.isFirstRun,
    notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    telemetryOptIn: telemetryOptIn ?? this.telemetryOptIn,
    menuDynamicEnabled: menuDynamicEnabled ?? this.menuDynamicEnabled,
    schemaVersion: schemaVersion ?? this.schemaVersion,
    appVersion: appVersion ?? this.appVersion,
  );

  Map<String, dynamic> toMap() => {
    'themeMode': themeMode.name,
    'locale': locale.languageCode,
    'menu': menu.map((e) => e.toMap()).toList(),
    'isFirstRun': isFirstRun,
    'notificationsEnabled': notificationsEnabled,
    'telemetryOptIn': telemetryOptIn,
    'menuDynamicEnabled': menuDynamicEnabled,
    'schemaVersion': schemaVersion,
    'appVersion': appVersion,
  };

  factory AppConfig.fromMap(Map<String, dynamic> map) => AppConfig(
    themeMode: _themeFrom(map['themeMode'] as String?),
    locale: Locale((map['locale'] as String?) ?? 'es'),
    menu: ((map['menu'] as List?) ?? const [])
        .map((e) => MenuItem.fromMap(Map<String, dynamic>.from(e)))
        .toList(),
    isFirstRun: (map['isFirstRun'] as bool?) ?? true,
    notificationsEnabled: (map['notificationsEnabled'] as bool?) ?? true,
    telemetryOptIn: (map['telemetryOptIn'] as bool?) ?? false,
    menuDynamicEnabled: (map['menuDynamicEnabled'] as bool?) ?? true,
    schemaVersion: (map['schemaVersion'] as int?) ?? 1,
    appVersion: map['appVersion'] as String?,
  );
}

ThemeMode _themeFrom(String? name) {
  switch (name) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    default:
      return ThemeMode.system;
  }
}
