import 'package:flutter_test/flutter_test.dart';
import 'package:fit_ai_app/store/settings/models/app_config.dart';
import 'package:fit_ai_app/store/settings/models/menu_item.dart';
import 'package:flutter/material.dart';

void main() {
  test('AppConfig toMap/fromMap roundtrip', () {
    final cfg = AppConfig(
      themeMode: ThemeMode.dark,
      locale: const Locale('en'),
      menu: const [
        MenuItem(
          id: 'dashboard',
          titleKey: 'menu.dashboard',
          route: '/',
          iconName: 'home',
        ),
      ],
      isFirstRun: false,
      notificationsEnabled: true,
      telemetryOptIn: false,
      menuDynamicEnabled: true,
      schemaVersion: 1,
      appVersion: '0.2.0-dev',
    );

    final map = cfg.toMap();
    final back = AppConfig.fromMap(map);

    expect(back.themeMode, ThemeMode.dark);
    expect(back.locale.languageCode, 'en');
    expect(back.menu.first.id, 'dashboard');
    expect(back.schemaVersion, 1);
  });
}
