part of 'main.dart';

// NOTE: only type
class EnvironmentType {
  String name;
  String description;
  String package;
  String version;
  String buildNumber;

  String settingName;
  String settingKey;

  List<TokenType> _token = const [];
  Iterable<APIType> api;

  List<ProductsType> products;
  Map<String, dynamic> settings;

  Map<String, Map<String, dynamic>> language;

  // individual
  Map<dynamic, dynamic> attach;

  EnvironmentType({
    required this.name,
    required this.description,
    required this.package,
    required this.version,
    required this.buildNumber,
    required this.settingName,
    required this.settingKey,
    // required this.token,
    List<TokenType>? token = const [],
    required this.api,
    required this.products,
    required this.settings,
    required this.attach,
    required this.language,
  }) {
    if (token != null) {
      _token = token;
    }
  }

  factory EnvironmentType.fromJSON(Map<String, dynamic> o) {
    return EnvironmentType(
      name: o['name'],
      description: o['description'],
      package: o['package'] ?? '',
      version: o['version'] ?? '1.0.0',
      buildNumber: o['buildNumber'] ?? '0',
      settingName: o['settingName'] ?? 's00',
      settingKey: o['settingKey'] ?? 's01',
      token: (o['token'] ?? '[]').map<TokenType>((e) => TokenType.fromJSON(e)).toList(),
      api: (o['api'] ?? '[]').map<APIType>((e) => APIType.fromJSON(e)).toList(),
      products: o['products'].map<ProductsType>((e) => ProductsType.fromJSON(e)).toList(),
      // settings: SettingType.fromJSON(o["settings"]),
      // settingsDemo: SettingsDemoType.fromJSONTesting(o["settings"]),
      // settingsDemo: (o["settings"] ?? {}).map((key, value) => MapEntry(key, value)),
      // settingsDemo: (o["settings"] ?? {}).cast<Map<String, dynamic>>(),
      settings: (o['settings'] ?? {}).cast<String, dynamic>(),
      language: (o['language'] ?? {}).cast<String, Map<String, dynamic>>(),
      attach: (o['attach'] ?? {}).map<dynamic, dynamic>((k, v) => MapEntry(k, v)),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      'settings': settings.toString(),
    };
  }

  /// track Uri used in Music
  /// ```dart
  /// Uri a = .url([api.uid]).uri(name: 2147)
  /// String b = .url([api.uid]).cache(2147)
  /// Uri first = .url('word').uri(name: '4354');
  /// Uri second = .url('word').uri(name: '4354', index: 1, scheme: 'http');
  /// String file = .url('word').cache('4354');
  /// String file = .url('word').local;
  /// ```
  APIType url(String id) {
    // _updateAPI();
    return _srcConfigure(api.lastWhere((e) => e.uid == id));
  }

  /// Update api based on token
  // void updateAPI() {
  //   api = api.map((e) {
  //     if (e.src.isNotEmpty) {
  //       e.src = e.src.map((e) => _srcConfigure(e));
  //     }
  //     return e;
  //   });
  // }

  // // patch Square Bracket
  // String _srcConfigure(String brackets) {
  //   return brackets.replaceAllMapped(
  //     RegExp(r'\[(.*?)\]'),
  //     (Match i) {
  //       final name = i.group(1);
  //       final lt = _token.where((o) => o.id == name);
  //       if (lt.isNotEmpty) {
  //         final url = GistData(owner: lt.first.owns, repo: lt.first.name);

  //         if (lt.first.type == 'repo') {
  //           return url.rawContentUri().toString();
  //         } else if (lt.first.type == 'gist') {
  //           return url.gitContentUri().toString();
  //         } else if (lt.first.type == 'url') {
  //           return url.uri().toString();
  //         }
  //       }
  //       return name.toString();
  //     },
  //   );
  // }

  /// Update api based on token
  void _updateAPI() {
    api = api.map((e) => _srcConfigure(e));
  }

  APIType _srcConfigure(APIType e) {
    if (e.src.isNotEmpty) {
      e.src = e.src.map((e) {
        // patch Square Bracket
        return e.replaceAllMapped(
          RegExp(r'\[(.*?)\]'),
          (Match i) {
            final name = i.group(1);
            final lt = _token.where((o) => o.id == name);
            if (lt.isNotEmpty) {
              final o = lt.first;

              final url = GistData(token: o);

              if (o.type == 'repo') {
                return url.rawContentUri().toString();
              } else if (o.type == 'gist') {
                return url.gitContentUri().toString();
              } else if (o.type == 'url') {
                return url.uri().toString();
              }
            }
            return name.toString();
          },
        );
      });
    }
    return e;
  }

  Future<void> updateToken({bool force = false, String file = 'env.json'}) async {
    final prev = await UtilDocument.exists(file);
    final String id = name.toLowerCase().replaceAll(' ', '');
    // final fileName = file.replaceAll('env', id);

    String raw = '';
    if (prev.isEmpty || force == true) {
      // delete previous version
      await UtilDocument.exists('token.json').then((String e) async {
        if (e.isNotEmpty) await UtilDocument.delete(e);
      });

      final res = await configure.gitContent<String>(file: file.replaceAll('env', id)).then((v) {
        debugPrint(' abc $v');
        return UtilDocument.decodeJSON<Map<String, dynamic>>(v);
      }).onError((error, stackTrace) {
        // debugPrint(error.toString());
        debugPrint(' abc $error');
        return {};
      });

      // configure.uri().toString()

      if (res.isEmpty) return Future.error('working');
      // if (res.isEmpty) return Future.error(configure.uri().toString());

      raw = await configure.gitContent<String>(file: res['env']).onError((error, stackTrace) {
        return '';
      });

      await UtilDocument.writeAsString(file, raw);
    } else {
      raw = await UtilDocument.readAsString(file);
    }

    if (raw.isEmpty) return Future.error('empty');

    final row = UtilDocument.decodeJSON<Map<String, dynamic>>(raw);

    final tok = (row['token']! as List).cast<dynamic>().map(
          (e) => TokenType.fromJSON(e),
        );
    for (var item in tok) {
      final index = _token.indexWhere((e) => e.id == item.id);
      if (index == -1) {
        _token.add(item);
      } else {
        _token[index] = item;
      }
    }
    _updateAPI();

    final lag = ((row['language'] ?? {}) as Map).cast<String, Map<String, dynamic>>();
    for (var entry in lag.entries) {
      // Add an empty `Map` to `mergedMap` if the key doesn't already exist
      // and then merge the `Map`s.
      (language[entry.key] ??= {}).addAll(entry.value);
    }
  }

  Future<void> updateTokenWorking({bool force = false, String file = 'token.json'}) {
    return UtilDocument.exists(file).then((String e) async {
      String tk = '';
      if (e.isEmpty || force == true) {
        final String id = name.toLowerCase().replaceAll(' ', '');
        await configure.gitContent<String>(file: file.replaceAll('token', id)).then((String e) {
          // tk = e;
          UtilDocument.writeAsString(file, tk = e);
        }).onError((e, stackTrace) {
          return Future.error(e.toString());
        });
      }

      debugPrint('updateToken???');

      try {
        if (tk.isEmpty) {
          tk = await UtilDocument.readAsString(file);
        }
      } catch (e) {
        return Future.error(e.toString());
      } finally {
        if (tk.isNotEmpty) {
          final tok = UtilDocument.decodeJSON<List<dynamic>>(tk).map(
            (e) => TokenType.fromJSON(e),
          );
          for (var item in tok) {
            final index = _token.indexWhere((elem) => elem.id == item.id);
            if (index == -1) {
              _token.add(item);
            } else {
              _token[index] = item;
            }
          }
          _updateAPI();
        }
      }

      // await UtilDocument.readAsString(file).then((e) {
      //   // _token.addAll(
      //   //   UtilDocument.decodeJSON<List<dynamic>>(e).map(
      //   //     (e) => TokenType.fromJSON(e),
      //   //   ),
      //   // );

      //   final tok = UtilDocument.decodeJSON<List<dynamic>>(e).map(
      //     (e) => TokenType.fromJSON(e),
      //   );
      //   for (var item in tok) {
      //     final index = _token.indexWhere((elem) => elem.id == item.id);
      //     if (index == -1) {
      //       _token.add(item);
      //     } else {
      //       _token[index] = item;
      //     }
      //   }
      //   _updateAPI();
      // }).onError((e, stackTrace) {
      //   return Future.error(e.toString());
      // });
    });
  }

  /// GistData by TokenType.id without token
  /// To fetch data
  GistData get configure {
    return openGistData('configure');
  }

  /// GistData by TokenType.id using token
  /// To push data
  GistData get client {
    return openGistData('client');
  }

  /// Initiate 'GistData' by 'TokenType.id'
  /// _token.lastWhere((e) => e.id == 'configure');
  /// _token.lastWhere((e) => e.id == 'client' && e.hasKey);
  GistData openGistData(String id) {
    TokenType o = _token.firstWhere((e) => e.id == id, orElse: () => const TokenType());
    // return GistData(id: o.id, owner: o.owns, repo: o.name, token: o.key);
    return GistData(token: o);
  }

  /// everything from `_token` except `_token.id != [configure,client]`
  Iterable<TokenType> get getSession {
    // return _token.where((e) => e.id != 'configure' || e.id != 'client' || e.id != 'repo');
    return _token.where((e) => e.id != 'configure' && e.id != 'client' && e.id != 'repo');
  }
}

/// NOTE: only type, EnvironmentType child
class APIType {
  final String uid;
  String assetName;
  String localName;
  Iterable<String> src;
  String name;
  Map<dynamic, String> query;

  APIType({
    required this.uid,
    required this.assetName,
    required this.localName,
    required this.src,
    required this.name,
    required this.query,
  });

  factory APIType.fromJSON(Map<String, dynamic> o) {
    return APIType(
      uid: o['uid'] as String,
      assetName: (o['asset'] ?? '').toString().gitHack(),
      localName: (o['local'] ?? '').toString().gitHack(),
      src: List.from(
        (o['src'] ?? []).map<String>((e) => e.toString().gitHack()),
      ),
      name: (o['name'] ?? '').toString().gitHack(),
      query: (o['query'] ?? {}).map<dynamic, String>((k, v) => MapEntry(k, v.toString())),
      // query: (o['query']??{}).map<dynamic, String>(
      //   (k, v) => MapEntry(k, v.toString().replaceFirst('??', _tableName))
      // ),
      // NOTE: .split('').reverse().join('')
      // src: List.from(
      //   (o['src']??[]).map<String>(
      //     (e) => e.toString().gitHack()
      //   )
      // )
      // child: List.from((o['child']??[]).map<APIType>((e) => APIType.fromJSON(e)))
    );
  }

  String get asset => assetName.replaceFirst('?', uid);
  String get local => localName.replaceFirst('?', uid);
  // String get repoName => repo.replaceFirst('!', uid);

  /// Uri
  /// ```dart
  /// // Uri
  /// .uri(name: '2147')
  /// .uri(name: '4354', index: 1, scheme: 'http');
  /// ```
  Uri uri({String? name, int index = 0, String scheme = 'https'}) {
    String url = '';
    if (src.isNotEmpty) {
      url = src.length > index ? src.elementAt(index) : src.first;
    }

    name ??= uid;
    Uri uri = Uri.parse(url.replaceFirst('!', name)).replace(scheme: scheme);
    if (uri.hasAuthority == false) {
      uri = uri.replace(host: 'example.com');
    }
    return uri;
    // String url = '';
    // if (src.isNotEmpty) {
    //   url = src.length > index ? src.elementAt(index) : src.first;
    // }
    // if (name == null) {
    //   name = uid;
    // }
    // Uri uri = Uri.parse(url.replaceFirst('!', '$name')).replace(scheme: scheme);
    // if (uri.hasAuthority == false) {
    //   uri = uri.replace(host: 'example.com');
    // }
    // return uri;
  }
  // Uri uri(Object? name, {int index = 0, String scheme = 'https'}) {
  //   String url = '';
  //   if (src.isNotEmpty) {
  //     url = src.length > index ? src.elementAt(index) : src.first;
  //   }

  //   name ??= uid;
  //   Uri uri = Uri.parse(url.replaceFirst('!', '$name')).replace(scheme: scheme);
  //   if (uri.hasAuthority == false) {
  //     uri = uri.replace(host: 'example.com');
  //   }
  //   return uri;
  //   // String url = '';
  //   // if (src.isNotEmpty) {
  //   //   url = src.length > index ? src.elementAt(index) : src.first;
  //   // }
  //   // if (name == null) {
  //   //   name = uid;
  //   // }
  //   // Uri uri = Uri.parse(url.replaceFirst('!', '$name')).replace(scheme: scheme);
  //   // if (uri.hasAuthority == false) {
  //   //   uri = uri.replace(host: 'example.com');
  //   // }
  //   // return uri;
  // }

  String cache(Object name) {
    return localName.replaceFirst('?', '$name');
  }

  // UsedIn: MyOrdbok
  // isMain == true is also built-in as bundle
  // bool get isMain => kind == 1 && src.length > 0;
  // bool get isChild => kind == 1 && src.length == 0;
  // bool get isAttach => kind == 0 && src.length > 0;
  bool get isMain => localName.isNotEmpty && assetName.isNotEmpty;
  bool get isChild => localName.isEmpty && assetName.isEmpty;
  bool get isAttach => localName.isNotEmpty && assetName.isEmpty;

  Iterable<MapEntry<dynamic, String>> get listQuery => query.entries;

  // Table name alias
  String get tableName => isAttach ? '$uid.$name' : name;
  // String get tableName => isAttach ? '$uid.$uid' : '$uid.$uid';
  // String get createIndex => listQuery.firstWhere((e) => e.key == 'createIndex',orElse: () => null)?.value?.replaceFirst('??', name);
  String? get createIndex {
    final val = listQuery.firstWhere((e) => e.key == 'createIndex');

    if (val.value.isNotEmpty) {
      return val.value.replaceAll('?!', tableName).replaceAll('#', uid).replaceAll('??', name);
    }
    return null;
  }
}

/// NOTE: only type, EnvironmentType child
class TokenType {
  final String id;
  final String type;
  final String tag;
  // final String dated;
  final String owns;
  final String name;
  final String key;
  final String clientId;
  final String clientSecret;

  const TokenType({
    this.id = '',
    this.type = '',
    this.tag = '',
    this.owns = '',
    this.name = '',
    this.key = '',
    this.clientId = '',
    this.clientSecret = '',
  });

  factory TokenType.fromJSON(Map<String, dynamic> o) {
    String tag = (o['tag'] ?? '').toString();
    return TokenType(
      id: (o['id'] ?? '').toString().bracketsHack(key: tag),
      type: (o['type'] ?? ''),
      tag: tag,
      owns: (o['owns'] ?? '').toString().bracketsHack(key: tag),
      name: (o['name'] ?? '').toString().bracketsHack(key: tag),
      key: (o['key'] ?? '').toString().bracketsHack(key: tag),
      clientId: (o['client-id'] ?? '').toString().bracketsHack(key: tag),
      clientSecret: (o['client-secret'] ?? '').toString().bracketsHack(key: tag),
    );
  }

  bool get hasId => id.isNotEmpty;
  bool get hasKey => key.isNotEmpty;
  bool get hasClient => clientId.isNotEmpty && clientSecret.isNotEmpty;
}
