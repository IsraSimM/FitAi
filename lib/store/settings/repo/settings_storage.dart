import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/log.dart';
import 'keys.dart';
import 'migrations.dart';

class SettingsSnapshot {
  final String themeMode; // 'light'|'dark'|'system'
  final String locale; // 'es'|'en'
  final List<String> enabledIds;
  final List<String> orderIds;
  final bool isFirstRun;
  final bool notificationsEnabled;
  final bool telemetryOptIn;
  final bool menuDynamicEnabled;
  final int schemaVersion;

  SettingsSnapshot({
    required this.themeMode,
    required this.locale,
    required this.enabledIds,
    required this.orderIds,
    required this.isFirstRun,
    required this.notificationsEnabled,
    required this.telemetryOptIn,
    required this.menuDynamicEnabled,
    required this.schemaVersion,
  });
}

class SettingsPartial {
  final String? themeMode;
  final String? locale;
  final List<String>? enabledIds;
  final List<String>? orderIds;
  final bool? isFirstRun;
  final bool? notificationsEnabled;
  final bool? telemetryOptIn;
  final bool? menuDynamicEnabled;

  const SettingsPartial({
    this.themeMode,
    this.locale,
    this.enabledIds,
    this.orderIds,
    this.isFirstRun,
    this.notificationsEnabled,
    this.telemetryOptIn,
    this.menuDynamicEnabled,
  });
}

class SettingsStorage {
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<SettingsSnapshot> load() async {
    final p = await _prefs;
    await SettingsMigrations.migrateIfNeeded(p);

    final theme = p.getString(kThemeMode) ?? 'system';
    final lang = p.getString(kLocale) ?? 'es';
    final enabledIds = _readStringListJson(p.getString(kMenuEnabled));
    final orderIds = _readStringListJson(p.getString(kMenuOrder));
    final firstRun = p.getBool(kIsFirstRun) ?? true;
    final notif = p.getBool(kNotifEnabled) ?? true;
    final tele = p.getBool(kTelemetry) ?? false;
    final dyn = p.getBool(kMenuDynamic) ?? true;
    final version = p.getInt(kSchemaVersion) ?? SettingsMigrations.current;

    logDebug(
      'Settings loaded: theme=$theme, locale=$lang, enabled=${enabledIds.length}',
    );

    return SettingsSnapshot(
      themeMode: theme,
      locale: lang,
      enabledIds: enabledIds,
      orderIds: orderIds,
      isFirstRun: firstRun,
      notificationsEnabled: notif,
      telemetryOptIn: tele,
      menuDynamicEnabled: dyn,
      schemaVersion: version,
    );
  }

  Future<void> savePartial(SettingsPartial s) async {
    final p = await _prefs;
    if (s.themeMode != null) {
      await p.setString(kThemeMode, s.themeMode!);
    }
    if (s.locale != null) {
      await p.setString(kLocale, s.locale!);
    }
    if (s.enabledIds != null) {
      await p.setString(kMenuEnabled, jsonEncode(s.enabledIds));
    }
    if (s.orderIds != null) {
      await p.setString(kMenuOrder, jsonEncode(s.orderIds));
    }
    if (s.isFirstRun != null) {
      await p.setBool(kIsFirstRun, s.isFirstRun!);
    }
    if (s.notificationsEnabled != null) {
      await p.setBool(kNotifEnabled, s.notificationsEnabled!);
    }
    if (s.telemetryOptIn != null) {
      await p.setBool(kTelemetry, s.telemetryOptIn!);
    }
    if (s.menuDynamicEnabled != null) {
      await p.setBool(kMenuDynamic, s.menuDynamicEnabled!);
    }

    if (!p.containsKey(kSchemaVersion)) {
      await p.setInt(kSchemaVersion, SettingsMigrations.current);
    }
    logDebug('Settings saved (partial).');
  }

  Future<void> reset() async {
    final p = await _prefs;
    for (final key in p.getKeys().where((k) => k.startsWith(kNs))) {
      await p.remove(key);
    }
    await p.setInt(kSchemaVersion, SettingsMigrations.current);
    logDebug('Settings reset to defaults (namespaced cleared).');
  }

  List<String> _readStringListJson(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final list = jsonDecode(raw) as List;
      return list.map((e) => e.toString()).toList();
    } catch (_) {
      return [];
    }
  }
}
