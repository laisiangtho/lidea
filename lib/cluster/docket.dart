import "package:lidea/hive.dart";
import "package:lidea/type.dart";
import "package:lidea/engine.dart";

abstract class ClusterDocket {
  bool requireInitialized = true;

  late EnvironmentType env;
  late Box<SettingType> boxOfSetting;
  late Box<PurchaseType> boxOfPurchase;
  late Box<RecentSearchType> boxOfRecentSearch;
  late GistData gist;

  // final time = watch..start(); time.elapsedMilliseconds
  // final Stopwatch watch = new Stopwatch();

  Future<void> ensureInitialized(Function? more) async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(PurchaseAdapter());
    Hive.registerAdapter(RecentSearchAdapter());
    if (more != null) {
      await more.call();
    }
  }

  Future<void> prepareInitialized(Function? more) async {
    env = EnvironmentType.fromJSON(
      UtilDocument.decodeJSON<Map<String, dynamic>>(
        await UtilDocument.loadBundleAsString('env.json'),
      ),
    );

    boxOfSetting = await Hive.openBox<SettingType>(env.settingName);
    SettingType active = setting;

    final _installs = boxOfSetting.isEmpty;
    final _updates = active.version != env.setting.version;
    requireInitialized = _installs || _updates;

    if (_installs) {
      boxOfSetting.put(
        env.settingKey,
        env.setting,
      );
    } else if (_updates) {
      boxOfSetting.put(
        env.settingKey,
        active.merge(env.setting),
      );
    }

    await tokenUpdate();

    boxOfPurchase = await Hive.openBox<PurchaseType>('purchase-list');
    // collection.boxOfSetting.clear();

    boxOfRecentSearch = await Hive.openBox<RecentSearchType>('recent-search');
    // await collection.boxOfRecentSearch.clear();

    if (more != null) {
      await more.call();
    }
  }

  Future<void> tokenUpdate({bool force = false, String file = 'token.json'}) {
    return env.updateToken(force: force, file: file).then((_) {
      gist = env.client;
    }).catchError((e) {
      gist = env.configure;
    });
  }

  SuggestionType cacheSuggestion = const SuggestionType();
  ConclusionType cacheConclusion = const ConclusionType();

  SettingType get setting => boxOfSetting.get(env.settingKey, defaultValue: env.setting)!;

  Future<void> settingUpdate(SettingType? value) async {
    if (value != null) {
      boxOfSetting.put(env.settingKey, value);
    }
  }

  String get searchQuery => setting.searchQuery;
  set searchQuery(String ord) {
    if (setting.searchQuery != ord) {
      setting.searchQuery = ord;
      settingUpdate(setting);
    }
  }

  // String get suggestQuery => '';
  // set suggestQuery(String ord) {
  //   if (suggestQuery != ord) {
  //     suggestQuery = ord;
  //   }
  // }
  String suggestQuery = '';

  double get fontSize => setting.fontSize;
  set fontSize(double size) {
    if (setting.fontSize != size) {
      settingUpdate(setting.copyWith(fontSize: size));
    }
  }

  bool stringCompare(String? a, String b) => a!.toLowerCase() == b.toLowerCase();

  // boxOfRecentSearch addWordHistory
  // bool hasNotHistory(String ord) => this.boxOfRecentSearch.values.firstWhere((e) => stringCompare(e,ord),orElse: ()=>'') == null;
  // bool hasNotHistory(String ord) => this.boxOfRecentSearch.values.firstWhere((e) => stringCompare(e,ord),orElse: () => '')!.isEmpty;

  MapEntry<dynamic, PurchaseType> boxOfPurchaseExist(String id) {
    return boxOfPurchase.toMap().entries.firstWhere(
          (e) => stringCompare(e.value.purchaseId, id),
          orElse: () => MapEntry(null, PurchaseType()),
        );
  }

  bool boxOfPurchaseDeleteByPurchaseId(String id) {
    if (id.isNotEmpty) {
      final purchase = boxOfPurchaseExist(id);
      if (purchase.key != null) {
        // this.boxOfRecentSearch.deleteAt(history.key);
        boxOfPurchase.delete(purchase.key);
        return true;
      }
    }
    return false;
  }

  // NOTE: History
  /// get all recentSearches
  Iterable<MapEntry<dynamic, RecentSearchType>> get recentSearches {
    return boxOfRecentSearch.toMap().entries;
  }

  /// recentSearch Exist of word
  MapEntry<dynamic, RecentSearchType> recentSearchExist(String ord) {
    return recentSearches.firstWhere(
      (e) => stringCompare(e.value.word, ord),
      orElse: () => MapEntry(null, RecentSearchType(word: ord)),
    );
  }

  /// recentSearch Update item if exist, if not insert
  bool recentSearchUpdate(String ord) {
    if (ord.isNotEmpty) {
      final ob = recentSearchExist(ord);
      ob.value.date = DateTime.now();
      ob.value.hit++;
      if (ob.key == null) {
        boxOfRecentSearch.add(ob.value);
      } else {
        boxOfRecentSearch.put(ob.key, ob.value);
      }
      return true;
    }
    return false;
  }

  /// recentSearch Delete item by word
  bool recentSearchDelete(String ord) {
    if (ord.isNotEmpty) {
      final ob = recentSearchExist(ord);
      if (ob.key != null) {
        boxOfRecentSearch.delete(ob.key);
        return true;
      }
    }
    return false;
  }

  Iterable<MapEntry<dynamic, RecentSearchType>> recentSearch() {
    // if (searchQuery.isEmpty) {
    //   return recentSearches;
    // } else {
    //   return recentSearches.where(
    //     (e) => e.value.word.toLowerCase().startsWith(searchQuery.toLowerCase()),
    //   );
    // }
    return recentSearches;
  }

  // recentSearchClear
  // void boxOfRecentSearchClear() {
  //   boxOfRecentSearch.clear();
  // }
}
