import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/settings_storage.dart';
import '../utils/debounce.dart';

class ThemeController extends Notifier<ThemeMode> {
  final _storage = SettingsStorage();
  final _debouncer = Debouncer(const Duration(milliseconds: 250));

  @override
  ThemeMode build() {
    ref.onDispose(_debouncer.dispose);
    return ThemeMode.system;
  }

  Future<void> bootstrap(String saved) async {
    state = _fromName(saved);
  }

  void setTheme(ThemeMode mode) {
    state = mode;
    _debouncer.run(() {
      _storage.savePartial(SettingsPartial(themeMode: mode.name));
    });
  }

  void toggleDark(bool on) => setTheme(on ? ThemeMode.dark : ThemeMode.light);

  Future<void> resetToDefaults() async {
    setTheme(ThemeMode.system);
  }

  ThemeMode _fromName(String name) {
    switch (name) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}

final themeControllerProvider = NotifierProvider<ThemeController, ThemeMode>(
  () => ThemeController(),
);
