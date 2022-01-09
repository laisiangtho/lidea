// import 'package:flutter/foundation.dart';

import "package:lidea/hive.dart";
import "package:lidea/extension.dart";
import "package:lidea/type/main.dart";
import "package:lidea/util/main.dart";

abstract class ClusterDocket {
  bool requireInitialized = true;

  late EnvironmentType env;
  late Box<SettingType> boxOfSetting;
  late Box<PurchaseType> boxOfPurchase;
  late Box<RecentSearchType> boxOfRecentSearch;
  late GistData gist;

  // final time = watch..start(); time.elapsedMilliseconds
  // final Stopwatch watch = new Stopwatch();
  /// Initiate primary context
  Future<void> ensureInitialized() async {
    await Hive.initFlutter();
    Hive.registerAdapter(SettingAdapter());
    Hive.registerAdapter(PurchaseAdapter());
    Hive.registerAdapter(RecentSearchAdapter());
  }

  /// Prepare necessary context
  Future<void> prepareInitialized() async {
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

  String suggestQuery = '';

  double get fontSize => setting.fontSize;
  set fontSize(double size) {
    if (setting.fontSize != size) {
      settingUpdate(setting.copyWith(fontSize: size));
    }
  }

  String get locale => setting.locale;
  set locale(String locale) {
    if (setting.locale != locale) {
      settingUpdate(setting.copyWith(locale: locale));
    }
  }

  bool stringCompare(String? a, String b) => a!.toLowerCase() == b.toLowerCase();

  String screenName(String? str) {
    return str!.removeNonAlphanumeric().toTitleCase(joiner: '');
  }

  String screenClass(String? str) {
    return str!.removeNonAlphanumeric().toTitleCase(joiner: '') + 'State';
  }

  // boxOfRecentSearch addWordHistory
  // bool hasNotHistory(String ord) => this.boxOfRecentSearch.values.firstWhere((e) => stringCompare(e,ord),orElse: ()=>'') == null;
  // bool hasNotHistory(String ord) => this.boxOfRecentSearch.values.firstWhere((e) => stringCompare(e,ord),orElse: () => '')!.isEmpty;

  // MapEntry<dynamic, PurchaseType> boxOfPurchaseExistPurchaseId(String? id) {
  //   return boxOfPurchase.toMap().entries.firstWhere(
  //         (e) => stringCompare(e.value.purchaseId, id!),
  //         orElse: () => MapEntry(null, PurchaseType()),
  //       );
  // }

  // bool boxOfPurchaseDeleteByPurchaseId(String id) {
  //   if (id.isNotEmpty) {
  //     final purchase = boxOfPurchaseExistPurchaseId(id);
  //     if (purchase.key != null) {
  //       // this.boxOfRecentSearch.deleteAt(history.key);
  //       boxOfPurchase.delete(purchase.key);
  //       return true;
  //     }
  //   }
  //   return false;
  // }

  // void boxOfPurchaseInsert({
  //   required String productId,
  //   required String purchaseId,
  //   bool? completePurchase,
  //   required String transactionDate,
  //   bool? consumable,
  // }) {
  //   boxOfPurchase.add(PurchaseType(
  //     productId: productId,
  //     purchaseId: purchaseId,
  //     completePurchase: completePurchase,
  //     transactionDate: transactionDate,
  //     consumable: consumable,
  //   ));
  // }

  // NOTE: History
  /// get all recentSearches
  Iterable<MapEntry<dynamic, RecentSearchType>> get recentSearches {
    return boxOfRecentSearch.toMap().entries;
  }

  /// recentSearch is EXIST by word
  MapEntry<dynamic, RecentSearchType> recentSearchExist(String ord) {
    return recentSearches.firstWhere(
      (e) => stringCompare(e.value.word, ord),
      orElse: () => MapEntry(null, RecentSearchType(word: ord)),
    );
  }

  /// recentSearch UPDATE on exist, if not INSERT
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

  /// recentSearch DELETE by word
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
    return recentSearches;
  }

  // recentSearchClear
  // void boxOfRecentSearchClear() {
  //   boxOfRecentSearch.clear();
  // }

  // int _rsIndex(String word) {
  //   return boxOfRecentSearch.toMap().values.toList().indexWhere((e) => e.word == word);
  // }

  // Future<void> _rsDelete(int index) => boxOfRecentSearch.deleteAt(index);
  // Future<void> favoriteSwitch(String word) {
  //   final index = _rsIndex(word);
  //   if (index >= 0) {
  //     return _rsDelete(index);
  //   } else {
  //     return boxOfRecentSearch.add(
  //       RecentSearchType(
  //         word: word,
  //         date: DateTime.now(),
  //       ),
  //     );
  //   }
  // }

  /// translate content from env,
  /// if require localeCode can be provided as second param,
  /// it is always withdraw to default if no match
  String language(String text, {String? localeCode}) {
    // localeName ?? Intl.systemLocale;
    final lN0 = localeCode ?? locale;
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

  // void tmpInterpret() {
  //   language('offlineaccess');
  //   language('offlineaccess', localeCode: 'en');
  // }

}
