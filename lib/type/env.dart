part of 'package:lidea/type.dart';

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
  });

  factory EnvironmentType.fromJSON(Map<String, dynamic> o) {
    return EnvironmentType(
      name: o["name"],
      description: o["description"],
      package: o["package"] ?? "",
      version: o["version"] ?? "1.0.0",
      buildNumber: o["buildNumber"] ?? "0",
      settingName: o["settingName"] ?? "0",
      settingKey: o["settingKey"] ?? "0",
      token: (o['token'] ?? "[]").map<TokenType>((e) => TokenType.fromJSON(e)).toList(),
      api: (o['api'] ?? "[]").map<APIType>((e) => APIType.fromJSON(e)).toList(),
      products: o['products'].map<ProductsType>((e) => ProductsType.fromJSON(e)).toList(),
      setting: SettingType.fromJSON(o["setting"]),
    );
  }

  Map<String, dynamic> toJSON() {
    return {
      "setting": setting.toString(),
    };
  }

  /// track Uri used in Music
  /// ```dart
  /// Uri a = .url([api.uid]).uri(2147)
  /// String b = .url([api.uid]).cache(2147)
  /// Uri first = .url('word').uri('4354');
  /// Uri second = .url('word').uri('4354', index: 1, scheme: 'http');
  /// String file = .url('word').cache('4354');
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
  String _srcConfigure(String obs) {
    return obs.replaceAllMapped(
      RegExp(r'\[(.*?)\]'),
      (Match i) {
        final name = i.group(1);
        final lt = token.where((e) => e.id == name);
        if (lt.isNotEmpty) {
          List<String> lq = ['/', lt.first.owns, lt.first.name];
          if (name == 'repo') {
            lq.insert(1, 'raw.githubusercontent.com');
            lq.add('master');
          } else if (name == 'gist') {
            lq.insert(1, 'gist.githubusercontent.com');
            lq.add('raw');
          }
          return lq.join('/');
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

  /// GistData gist with token using TokenType id
  GistData get configure {
    return GistData(
      owner: _tokenConfigure.owns,
      repo: _tokenConfigure.name,
    );
  }

  TokenType get _tokenClient => token.lastWhere((e) => e.id == 'client' && e.id.isNotEmpty);

  /// GistData gist with token using TokenType id
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
  String uid;
  String asset;
  String local;
  // String repo;
  Iterable<String> src;

  APIType({
    required this.uid,
    required this.asset,
    required this.local,
    // required this.repo,
    required this.src,
  });

  factory APIType.fromJSON(Map<String, dynamic> o) {
    return APIType(
      uid: o["uid"] as String,
      asset: (o['asset'] ?? "").toString().gitHack(),
      local: (o['local'] ?? "").toString().gitHack(),
      // repo: (o['repo'] ?? "").toString().gitHack(),
      src: List.from(
        (o['src'] ?? []).map<String>((e) => e.toString().gitHack()),
      ),
    );
  }

  String get assetName => asset.replaceFirst('?', uid);
  String get localName => local.replaceFirst('?', uid);
  // String get repoName => repo.replaceFirst('!', uid);

  /// Uri
  /// ```dart
  /// // Uri
  /// .uri('2147')
  /// .uri('4354', index: 1, scheme: 'http');
  /// ```
  Uri uri(String id, {int index = 0, String scheme = 'https'}) {
    String url = '';
    if (src.isNotEmpty) {
      url = src.length > index ? src.elementAt(index) : src.first;
    }
    Uri uri = Uri.parse(url.replaceFirst('!', id)).replace(scheme: scheme);
    if (uri.hasAuthority == false) {
      uri = uri.replace(host: 'example.com');
    }
    return uri;
    // if (uri.hasQuery) {
    //   return Uri.https(uri.authority, uri.path, uri.queryParameters);
    // }
    // return Uri.https(uri.authority, uri.path);
  }

  String cache(Object id) {
    return local.replaceFirst('?', id.toString());
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
