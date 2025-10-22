import 'package:shared_preferences/shared_preferences.dart';
import 'keys.dart';

/// Simple schema migration scaffold. Extend as schema evolves.
class SettingsMigrations {
  static const int current = 1;

  static Future<void> migrateIfNeeded(SharedPreferences prefs) async {
    final stored = prefs.getInt(kSchemaVersion) ?? 0;
    if (stored == current) return;

    // Example future migrations:
    // if (stored < 1) { /* set defaults / transform keys */ }

    await prefs.setInt(kSchemaVersion, current);
  }
}
