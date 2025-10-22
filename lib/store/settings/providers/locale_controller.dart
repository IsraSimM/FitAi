import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../repo/settings_storage.dart';
import '../utils/debounce.dart';

class LocaleController extends Notifier<Locale> {
  final _storage = SettingsStorage();
  final _debouncer = Debouncer(const Duration(milliseconds: 250));

  @override
  Locale build() {
    ref.onDispose(_debouncer.dispose);
    return const Locale('es');
  }

  Future<void> bootstrap(String saved) async {
    state = Locale(saved);
  }

  void setLocale(Locale l) {
    state = l;
    _debouncer.run(() {
      _storage.savePartial(SettingsPartial(locale: l.languageCode));
    });
  }

  Future<void> resetToDefaults() async {
    setLocale(const Locale('es'));
  }
}

final localeControllerProvider = NotifierProvider<LocaleController, Locale>(
  () => LocaleController(),
);
