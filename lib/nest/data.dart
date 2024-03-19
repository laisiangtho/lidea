part of 'main.dart';

//
class DataNest {
// retrieve the instance through the app
  // ClusterDocket.internal();
  late final HiveInterface hive = Hive;

  final void Function() notify;

  late EnvironmentType env;
  // late GistData gist;

  late bool _isInstalls;
  late bool _isUpdates;
  bool get requireInitialized => _isInstalls || _isUpdates;
  bool get isIntalls => _isInstalls;
  bool get isUpdated => _isUpdates;

  late final boxOfSettings = BoxOfSettings<SettingsType>();
  late final boxOfRecentSearch = BoxOfRecentSearch<RecentSearchType>();
  late final boxOfFavoriteWord = BoxOfFavoriteWord<FavoriteWordType>();
  late final boxOfPurchases = BoxOfPurchases<PurchasesType>();

  late final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // final Stopwatch watch = Stopwatch()..start();
  // final Stopwatch watch = new Stopwatch();
  // final time = watch..start(); time.elapsedMilliseconds
  /// Initiate primary context
  // Future<void> ensureWhat() async {
  //   await Firebase.initializeApp(name: 'Lai Siangtho');
  //   await hive.initFlutter();
  // }

  DataNest({required this.notify});

  Future<void> ensureInitialized() async {
    await hive.initFlutter();
    notify();

    boxOfSettings.registerAdapter(SettingsAdapter());
    boxOfRecentSearch.registerAdapter(RecentSearchAdapter());
    boxOfFavoriteWord.registerAdapter(FavoriteWordAdapter());
    boxOfPurchases.registerAdapter(PurchasesAdapter());
  }

  CollectionReference<Map<String, dynamic>> get userCollection {
    return firestore.collection('user');
  }

  CollectionReference<UserType> get userReference {
    return userCollection.withConverter<UserType>(
      fromFirestore: (snapshots, _) => UserType.fromJSON(snapshots.data()!),
      toFirestore: (user, _) => user.toJSON(),
    );
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
    _isUpdates = boxOfSettings.checkVersion(env.settings['version']);

    boxOfSettings.fromJSON(env.settings);

    debugPrint('_isInstalls: $_isInstalls _isUpdates: $_isUpdates');

    await updateToken(force: requireInitialized);

    await boxOfRecentSearch.open('recent-search');
    // NOTE: orginal name is "favorite"??
    await boxOfFavoriteWord.open('favorite-word');
    await boxOfPurchases.open('purchase-list');
  }

  // gist
  Future<void> updateToken({bool force = false}) {
    return env.updateToken(force: force, file: 'env.json').then((_) {
      // gist = env.client;
    }).catchError((e) {
      // gist = env.configure;
      debugPrint('updateToken $e ');
    });
  }

  // SuggestionType cacheSuggestion = const SuggestionType();
  // ConclusionType cacheConclusion = const ConclusionType();

  String get searchQuery => boxOfSettings.searchQuery().asString;
  set searchQuery(String ord) {
    if (searchQuery != ord) {
      notify();
    }
    boxOfSettings.searchQuery(value: ord);
  }

  String get suggestQuery => boxOfSettings.suggestQuery().asString;
  set suggestQuery(String ord) {
    final word = ord.replaceAll(RegExp(' +'), ' ').trim();
    if (suggestQuery != word) {
      notify();
    }
    boxOfSettings.suggestQuery(value: word);
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
    const lN1 = 'en';

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

  /// Platform operating system: `web, android, fuchsia, ios, linux, macos, windows`
  String get platform {
    if (kIsWeb) {
      return 'web';
    }

    return Platform.operatingSystem;
  }

  /// name: `web, android, fuchsia, ios, linux, macos, windows`
  /// Platform.isAndroid
  /// Platform.isIOS
  bool isPlatform(String name) {
    return platform == name;
  }

  Random random({int? seed}) {
    return Random(seed);
  }

  int randomNumber(int? max) {
    if (max != null) {
      return random().nextInt(max) + 1;
    }
    return random().nextInt(150);
  }

  bool randomBool() {
    return random().nextBool();
  }

  double randomDouble() {
    return random().nextDouble();
  }

  String get randomChars => 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String randomString(int length) {
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => randomChars.codeUnitAt(
          random().nextInt(randomChars.length),
        ),
      ),
    );
  }
}
