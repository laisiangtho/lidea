import 'package:flutter/material.dart';
import 'package:lidea/unit/notify.dart';

abstract class UnitController extends Notify {
  late BuildContext context;
  late ThemeMode _themeMode;

  // UnitController(this.context);

  ThemeMode get themeMode => _themeMode;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<void> ensureInitialized() async {
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e == ThemeMode.values.elementAt(mode),
      orElse: () => ThemeMode.system,
    );

    notify();
  }

  int get mode => 0;

  Locale get locale {
    // final lang = _setting.locale;
    // final asdf = Locale(Intl.systemLocale);
    // debugPrint('service-lang ${Intl.systemLocale}: $lang: ${asdf.countryCode}');
    return Locale('en');
  }

  Future<void> saveMode(ThemeMode newMode) async {}
  Future<void> saveLocale(Locale newLocale) async {}

  Future<void> updateThemeMode(ThemeMode? newMode) async {
    if (newMode == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newMode == _themeMode) return;

    // Otherwise, store the new theme mode in memory
    _themeMode = newMode;

    // Inform listeners a change has occurred.
    notify();
    // Persist the changes to a local database or the internet using the
    await saveMode(newMode);
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// Returns the active [Brightness].
  Brightness get systemBrightness {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance!.window.platformBrightness;
    }
    return brightness;
  }

  /// Returns opposite of active [Brightness].
  Brightness get resolvedSystemBrightness {
    return systemBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newLocale == locale) return;

    // Otherwise, store the new theme mode in memory
    await saveLocale(newLocale);
    // Inform listeners a change has occurred.
    notify();
  }
}

abstract class UnitControllerTmp extends Notify {
  late BuildContext context;
  late ThemeMode _themeMode;

  ThemeMode get themeMode => _themeMode;

  /// Loads the User's preferred ThemeMode from local or remote storage.
  Future<void> ensureInitialized() async {
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e == ThemeMode.values.elementAt(mode),
      orElse: () => ThemeMode.system,
    );

    notify();
  }

  int get mode => 0;

  Locale get locale {
    // final lang = _setting.locale;
    // final asdf = Locale(Intl.systemLocale);
    // debugPrint('service-lang ${Intl.systemLocale}: $lang: ${asdf.countryCode}');
    return Locale('en');
  }

  Future<void> saveMode(ThemeMode newMode) async {}
  Future<void> saveLocale(Locale newLocale) async {}

  Future<void> updateThemeMode(ThemeMode? newMode) async {
    if (newMode == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newMode == _themeMode) return;

    // Otherwise, store the new theme mode in memory
    _themeMode = newMode;

    // Inform listeners a change has occurred.
    notify();
    // Persist the changes to a local database or the internet using the
    await saveMode(newMode);
  }

  bool get isDarkMode => themeMode == ThemeMode.dark;

  /// Returns the active [Brightness].
  Brightness get systemBrightness {
    Brightness brightness;
    switch (themeMode) {
      case ThemeMode.light:
        brightness = Brightness.light;
        break;
      case ThemeMode.dark:
        brightness = Brightness.dark;
        break;
      default:
        brightness = WidgetsBinding.instance!.window.platformBrightness;
    }
    return brightness;
  }

  /// Returns opposite of active [Brightness].
  Brightness get resolvedSystemBrightness {
    return systemBrightness == Brightness.dark ? Brightness.light : Brightness.dark;
  }

  Future<void> updateLocale(Locale? newLocale) async {
    if (newLocale == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (newLocale == locale) return;

    // Otherwise, store the new theme mode in memory
    await saveLocale(newLocale);
    // Inform listeners a change has occurred.
    notify();
  }
}
