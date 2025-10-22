import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fit_ai_app/store/settings/repo/settings_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('SettingsStorage saves and loads partials', () async {
    SharedPreferences.setMockInitialValues({});
    final storage = SettingsStorage();

    await storage.savePartial(
      const SettingsPartial(themeMode: 'dark', locale: 'en'),
    );
    final snap = await storage.load();

    expect(snap.themeMode, 'dark');
    expect(snap.locale, 'en');
  });
}
