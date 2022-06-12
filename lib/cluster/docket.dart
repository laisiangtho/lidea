part of lidea.cluster;

class ClusterDocket {
// retrieve the instance through the app
  // ClusterDocket.internal();

  late EnvironmentType env;
  late GistData gist;

  late bool _isInstalls;
  late bool _isUpdates;
  bool get requireInitialized => _isInstalls || _isUpdates;

  late final boxOfSettings = BoxOfSettings<SettingsType>();
  late final boxOfPurchases = BoxOfPurchases<PurchasesType>();
  late final boxOfRecentSearch = BoxOfRecentSearch<RecentSearchType>();

  // final time = watch..start(); time.elapsedMilliseconds
  // final Stopwatch watch = new Stopwatch();
  /// Initiate primary context
  Future<void> ensureInitialized() async {
    await Hive.initFlutter();
    boxOfSettings.registerAdapter(SettingsAdapter());
    boxOfPurchases.registerAdapter(PurchasesAdapter());
    boxOfRecentSearch.registerAdapter(RecentSearchAdapter());
  }

  /// Prepare necessary context
  Future<void> prepareInitialized() async {
    env = EnvironmentType.fromJSON(
      UtilDocument.decodeJSON<Map<String, dynamic>>(
        await UtilDocument.loadBundleAsString('env.json'),
      ),
    );

    await boxOfSettings.open(env.settingName);

    _isInstalls = boxOfSettings.box.isEmpty;

    // NOTE: delete previous settings
    // if (!_isInstalls) {
    //   boxOfSettings.box.delete(env.settingKey);
    // }

    // if (await boxOfSettings.instance.boxExists('')) {
    //   boxOfSettings.instance.deleteBoxFromDisk('');
    // }

    _isUpdates = boxOfSettings.checkVersion(env.settings['version']);
    boxOfSettings.fromJSON(env.settings);

    await updateToken(force: requireInitialized);

    await boxOfPurchases.open('purchase-list');
    await boxOfRecentSearch.open('recent-search');
  }

  // gist
  Future<void> updateToken({bool force = false, String file = 'token.json'}) {
    return env.updateToken(force: force, file: file).then((_) {
      gist = env.client;
    }).catchError((e) {
      gist = env.configure;
    });
  }

  // SuggestionType cacheSuggestion = const SuggestionType();
  // ConclusionType cacheConclusion = const ConclusionType();

  SettingsType get searchQuery => boxOfSettings.searchQuery();
  set searchQuery(Object ord) {
    boxOfSettings.searchQuery(value: ord);
  }

  SettingsType get suggestQuery => boxOfSettings.suggestQuery();
  set suggestQuery(Object ord) {
    boxOfSettings.suggestQuery(value: ord);
  }

  /// translate content from env,
  /// if require localeCode can be provided as second param,
  /// it is always withdraw to default if no match
  /// ```dart
  /// .language('offlineaccess');
  /// .language('offlineaccess', localeCode: 'en');
  /// ```
  String language(String text, {String? localeCode}) {
    // localeName ?? Intl.systemLocale;
    // final lN0 = localeCode ?? boxOfSettings.searchQuery().toString();
    // final lN0 = localeCode ?? locale.asString;
    final lN0 = localeCode ?? boxOfSettings.locale().asString;
    // final lN0 = localeCode ?? '';
    final lN1 = 'en';

    final l01 = env.language.entries;
    final l02 = l01.first;

    final l20 = l01.firstWhere((e) => e.key == lN0, orElse: () => l02);

    final l21 = l20.value.entries.firstWhere(
      (e) => e.key == text,
      orElse: () {
        if (lN0 == lN1) {
          // Select language and default the same
          return MapEntry('', text);
        } else {
          // No match in selected language
          return l02.value.entries.firstWhere(
            (e) => e.key == text,
            orElse: () => MapEntry('', text),
          );
        }
      },
    );

    return l21.value;
  }
}
