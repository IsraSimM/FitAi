import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_config.dart';
import '../models/menu_item.dart';
import '../repo/settings_storage.dart';
import 'theme_controller.dart';
import 'locale_controller.dart';
import 'menu_controller.dart';

/// Composes the global AppConfig from domain controllers and storage flags.
final appConfigProvider = Provider<AppConfig>((ref) {
  final theme = ref.watch(themeControllerProvider);
  final locale = ref.watch(localeControllerProvider);
  final menuState = ref.watch(menuControllerProvider);

  // Materialize menu view
  final List<MenuItem> menu = ref
      .read(menuControllerProvider.notifier)
      .materialize();

  // Flags from storage snapshot might be needed; for simplicity, derive from menuState + defaults
  final cfg = AppConfig(
    themeMode: theme,
    locale: locale,
    menu: menu,
    isFirstRun: false, // will be set on bootstrap
    notificationsEnabled: true, // storage sets real values during bootstrap
    telemetryOptIn: false,
    menuDynamicEnabled: menuState.dynamicEnabled,
    schemaVersion: 1,
    appVersion: null,
  );
  return cfg;
});

/// Bootstrap helper to read SharedPreferences once at startup and seed controllers.
final appBootstrapProvider = FutureProvider<void>((ref) async {
  final storage = SettingsStorage();
  final snap = await storage.load();

  await ref.read(themeControllerProvider.notifier).bootstrap(snap.themeMode);
  await ref.read(localeControllerProvider.notifier).bootstrap(snap.locale);
  await ref
      .read(menuControllerProvider.notifier)
      .bootstrap(
        enabled: snap.enabledIds,
        order: snap.orderIds,
        dynamicEnabled: snap.menuDynamicEnabled,
      );

  // Optionally: handle first run flag
  if (snap.isFirstRun) {
    await storage.savePartial(const SettingsPartial(isFirstRun: false));
  }
});
