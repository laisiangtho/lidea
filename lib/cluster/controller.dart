part of lidea.cluster;

abstract class ClusterController with ChangeNotifier {
  late BuildContext context;
  late ClusterDocket _docket;

  ClusterController(ClusterDocket docket) {
    _docket = docket;
  }

  late ThemeMode _themeMode;
  ThemeMode get themeMode => _themeMode;

  /// `AppLocalizations.of(context)!`;
  dynamic get text => Object();

  /// `AppLocalizations.supportedLocales`
  Iterable<Locale> get listOfLocale => const [
        Locale('no', 'NO'),
        Locale('my', ''),
        Locale('en', 'GB'),
      ];

  String nameOfTheme(int index) {
    switch (index) {
      case 1:
        return text.light;
      case 2:
        return text.dark;
      default:
        return text.automatic;
    }
  }

  String nameOfLocale(String languageCode) {
    // Intl.shortLocale(Intl.systemLocale)
    switch (languageCode) {
      case 'en':
        return 'English';
      case 'my':
        return 'မြန်မာ';
      case 'no':
        return 'Norsk';
      default:
        return 'Other';
    }
  }

  /// env language
  String language(String text) => _docket.language(text);

  // Loads the User's preferred ThemeMode from local or remote storage.
  Future<void> ensureInitialized() async {
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e == ThemeMode.values.elementAt(mode),
      orElse: () => ThemeMode.system,
    );
    // notifyListeners();
  }

  /// set BuildContext, use in controller
  void setContext(BuildContext _context) {
    context = _context;
    _docket.boxOfSettings.locale(value: Localizations.localeOf(context).languageCode);
  }

  // int get mode => 0;
  // Locale get locale => Locale('en');
  // Future<void> saveMode(ThemeMode newMode) async {}
  // Future<void> saveLocale(Locale newLocale) async {}

  // themeMode themeLocale
  int get mode {
    // if (initialized) {
    //   debugPrint('??? mode setting');
    //   return _docket.boxOfSettings.mode().asInt;
    // }
    // debugPrint('??? mode static');
    // return 0;
    return _docket.boxOfSettings.mode().asInt;
  }

  Locale get locale {
    // return Locale('en');
    // if (initialized) {
    //   final lang = _docket.boxOfSettings.locale().asString;
    //   return Locale(lang.isEmpty ? Intl.systemLocale : lang, '');
    // }
    // return Locale('en');
    final lang = _docket.boxOfSettings.locale().asString;
    return Locale(lang.isEmpty ? Intl.systemLocale : lang, '');
  }

  Future<void> saveMode(ThemeMode value) async {
    _docket.boxOfSettings.mode(
      value: ThemeMode.values.indexOf(value),
    );
  }

  Future<void> saveLocale(Locale value) async {
    _docket.boxOfSettings.locale(
      value: value.languageCode,
    );
  }

  Future<void> updateThemeMode(ThemeMode? value) async {
    if (value == null) return;

    // Dot not perform any work if new and old ThemeMode are identical
    if (value == _themeMode) return;

    // Otherwise, store the new theme mode in memory
    _themeMode = value;

    // Inform listeners a change has occurred.
    notifyListeners();
    // Persist the changes to a local database or the internet using the
    await saveMode(value);
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
        brightness = WidgetsBinding.instance.window.platformBrightness;
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
    notifyListeners();
  }
}
