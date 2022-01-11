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

  List<TokenType> token;
  Iterable<APIType> api;

  List<ProductsType> products;
  SettingType setting;

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
    required this.token,
    required this.api,
    required this.products,
    required this.setting,
    required this.attach,
    required this.language,
  });

  factory EnvironmentType.fromJSON(Map<String, dynamic> o) {
    return EnvironmentType(
      name: o["name"],
      description: o["description"],
      package: o["package"] ?? "",
      version: o["version"] ?? "1.0.0",
      buildNumber: o["buildNumber"] ?? "0",
      settingName: o["settingName"] ?? "s00",
      settingKey: o["settingKey"] ?? "s01",
      token: (o['token'] ?? "[]").map<TokenType>((e) => TokenType.fromJSON(e)).toList(),
      api: (o['api'] ?? "[]").map<APIType>((e) => APIType.fromJSON(e)).toList(),
      products: o['products'].map<ProductsType>((e) => ProductsType.fromJSON(e)).toList(),
      setting: SettingType.fromJSON(o["setting"]),
      language: (o['language'] ?? {}).cast<String, Map<String, dynamic>>(),
      attach: (o['attach'] ?? {}).map<dynamic, dynamic>((k, v) => MapEntry(k, v)),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "setting": setting.toString(),
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
    return api.lastWhere((e) => e.uid == id);
  }

  /// Update api based on token
  void updateAPI() {
    api = api.map((e) {
      if (e.src.isNotEmpty) {
        e.src = e.src.map((e) => _srcConfigure(e));
      }
      return e;
    });
  }

  // patch Square Bracket
  String _srcConfigure(String brackets) {
    return brackets.replaceAllMapped(
      RegExp(r'\[(.*?)\]'),
      (Match i) {
        final name = i.group(1);
        final lt = token.where((e) => e.id == name);
        if (lt.isNotEmpty) {
          final url = GistData(owner: lt.first.owns, repo: lt.first.name);

          if (lt.first.type == 'repo') {
            return url.rawContentUri().toString();
          } else if (lt.first.type == 'gist') {
            return url.gitContentUri().toString();
          } else if (lt.first.type == 'url') {
            return url.uri().toString();
          }
        }
        return name.toString();
      },
    );
  }

  Future<void> updateToken({bool force = false, String file = 'token.json'}) {
    return UtilDocument.exists(file).then((String e) async {
      if (e.isEmpty || force == true) {
        final String id = name.toLowerCase().replaceAll(' ', '');

        await configure.gitContent<String>(file: file.replaceAll('token', id)).then((String e) {
          UtilDocument.writeAsString(file, e);
        }).onError((e, stackTrace) {
          return Future.error(e.toString());
        });
      }

      await UtilDocument.readAsString(file).then((e) {
        token.addAll(
          UtilDocument.decodeJSON<List<dynamic>>(e).map(
            (e) => TokenType.fromJSON(e),
          ),
        );
        updateAPI();
      }).onError((e, stackTrace) {
        return Future.error(e.toString());
      });
    });
  }

  TokenType get _tokenConfigure => token.lastWhere((e) => e.id == 'configure');

  /// GistData gist without token using TokenType id
  /// To fetch data
  GistData get configure {
    return GistData(
      owner: _tokenConfigure.owns,
      repo: _tokenConfigure.name,
    );
  }

  TokenType get _tokenClient => token.lastWhere((e) => e.id == 'client' && e.key.isNotEmpty);

  /// GistData gist with token using TokenType id
  /// To push data
  GistData get client {
    return GistData(
      owner: _tokenClient.owns,
      repo: _tokenClient.name,
      token: _tokenClient.key,
      // file: '${authentication.id}.json',
    );
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
      uid: o["uid"] as String,
      assetName: (o['asset'] ?? "").toString().gitHack(),
      localName: (o['local'] ?? "").toString().gitHack(),
      src: List.from(
        (o['src'] ?? []).map<String>((e) => e.toString().gitHack()),
      ),
      name: (o['name'] ?? "").toString().gitHack(),
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
  Uri uri({Object? name, int index = 0, String scheme = 'https'}) {
    String url = '';
    if (src.isNotEmpty) {
      url = src.length > index ? src.elementAt(index) : src.first;
    }
    if (name == null) {
      name = uid;
    }
    Uri uri = Uri.parse(url.replaceFirst('!', '$name')).replace(scheme: scheme);
    if (uri.hasAuthority == false) {
      uri = uri.replace(host: 'example.com');
    }
    return uri;
  }

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

  const TokenType({
    required this.id,
    required this.type,
    required this.tag,
    required this.owns,
    required this.name,
    required this.key,
  });

  factory TokenType.fromJSON(Map<String, dynamic> o) {
    String tag = (o["tag"] ?? '').toString();
    return TokenType(
      id: (o["id"] ?? '').toString().bracketsHack(key: tag),
      type: (o["type"] ?? ''),
      tag: tag,
      owns: (o["owns"] ?? '').toString().bracketsHack(key: tag),
      name: (o["name"] ?? '').toString().bracketsHack(key: tag),
      key: (o["key"] ?? '').toString().bracketsHack(key: tag),
    );
  }

  bool get hasKey => key.isNotEmpty;
}
