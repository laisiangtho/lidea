part of '../main.dart';

/// https://gist.github.com/[?]/
///
/// token: Personal access token
/// download and extract zip from Gist files which are truncated: true
///
/// `gist.token` can be provided later for updateFile, removeFile
///
/// ```dart
/// final gist = GistData(owner:'?', repo:?, token:?);
/// gist.gitContent();
/// gist.rawContent();
/// gist.gitFiles();
/// gist.testDownloadAndExtract();
///
/// ```
class GistData {
  late final urlRawGist = Uri.https('gist.githubusercontent.com', '/owner/repo/raw/id/file');
  // https://api.github.com/rate_limit
  late final urlGistBlock = Uri.https('api.github.com', '/gists/repo');
  late final urlRawRepo = Uri.https('raw.githubusercontent.com', '/owner/repo/master/file');

  final TokenType token;
  String? file;

  /// api.github.com/gists/repo
  /// create default client
  GistData({required this.token, this.file});

  AskNest get _ask => AskNest(urlGistBlock.replace(path: '/gists/${token.name}'));

  Uri uri({String? owner, String? repo, Map<String, dynamic>? args}) {
    owner ??= token.owns;
    repo ??= token.name;
    return Uri.https(owner, repo, args);
  }

  /// gist.githubusercontent.com/owner/repo/raw/id/file
  /// ```dart
  /// final gist = GistData(owner: '?', repo: '?');
  /// await gist.gitContent<String>(file: '?').then((String res) {
  ///   debugPrint('result $res');
  /// }).catchError((e) {
  ///   debugPrint('error $e');
  /// });
  /// ```
  Uri gitContentUri({String? owner, String? repo, String? file}) {
    owner ??= token.owns;
    repo ??= token.name;
    if (file != null && file.isNotEmpty) {
      return urlRawGist.replace(path: '/$owner/$repo/raw/$file');
    }
    return urlRawGist.replace(path: '/$owner/$repo/raw/');
  }

  Future<T> gitContent<T>({String? owner, String? repo, String? file, bool url = false}) async {
    if (file != null && file.isNotEmpty) {
      return AskNest(gitContentUri(owner: owner, repo: repo, file: file)).get<T>();
    }
    return Future<T>.error('No identity');
  }

  /// raw.githubusercontent.com/owner/repo/master/file
  /// ```dart
  /// final gist = GistData(owner: '?', repo: '?');
  /// await gist.rawContent<String>(file: '?').then((String res) {
  ///   debugPrint('result $res');
  /// }).catchError((e) {
  ///   debugPrint('error $e');
  /// });
  /// ```
  Uri rawContentUri({String? owner, String? repo, String? file}) {
    owner ??= token.owns;
    repo ??= token.name;
    if (file != null && file.isNotEmpty) {
      return urlRawRepo.replace(path: '/$owner/$repo/master/$file');
    }
    return urlRawRepo.replace(path: '/$owner/$repo/master/');
  }

  Future<T> rawContent<T>({String? owner, String? repo, String? file}) async {
    owner ??= token.owns;
    repo ??= token.name;
    if (file == null && this.file != null) {
      file = this.file;
    }
    if (file != null && file.isNotEmpty) {
      return AskNest(rawContentUri(owner: owner, repo: repo, file: file)).get<T>();
    }
    return Future<T>.error('No identity');
  }

  // header for post, delete, patch
  Map<String, String> header({String? key}) {
    key ??= token.key;
    return {
      'Accept': 'application/vnd.github.v3+json',
      if (token.hasClient) token.clientId: token.clientSecret,
      // if (token.hasClient) '${token.clientId}': '${token.clientSecret}',
      if (key.isNotEmpty) 'Authorization': 'token $key',
      // 'Authorization': 'Basic a:b',
      // 'Content-type': 'application/json',
      'User-Agent': 'lidea',
    };
  }

  /// download and extract zip from Gist files which are truncated: true
  /// ```dart
  /// final gist = GistData(....);
  /// gist.testDownloadAndExtract();
  /// ```
  Future<List<String>> testDownloadAndExtract() {
    return gitFiles().then((res) async {
      final List<String> result = [];
      final files = res.where((e) => e['type'] == 'application/zip');
      for (var item in files) {
        if (item['truncated'] == false) {
          final bytes = await UtilDocument.strToListInt(item['content']);
          await ArchiveNest.extract(bytes);
        } else {
          await AskNest(item['url']).get<Uint8List>().then((res) async {
            ArchiveNest.extract(res).then((arc) async {
              for (var fileName in arc!) {
                final isExists = await UtilDocument.exists(fileName);
                debugPrint('$fileName added: $isExists');
              }
              // arc!.forEach((fileName) async {
              //   final isExists = await UtilDocument.exists(fileName);
              //   debugPrint('$fileName added: $isExists');
              // });
            });
          });
        }
      }
      return result;
    });
  }

  /// get list of Gist files
  /// ```dart
  /// final gist = GistData(repo:?);
  /// gist.listFile();
  /// ```
  // {bool forceTruncated = false}
  // Future<GistListicleType> listFile() {
  //   return _ask.get<String>(headers: header()).then<GistListicleType>(
  //     (res) {
  //       final src = UtilDocument.decodeJSON<Map<String, dynamic>>(res);
  //       // gistId, dataId
  //       Map<String, dynamic> raw = {
  //         'gistId': src['id'],
  //         'dataId': token.id,
  //         'comments': src['comments'],
  //         'description': src['description'],
  //       };
  //       raw['files'] = src['files'].values;
  //       // raw['files'] = await src['files'].values.map((entry) async {
  //       //   if (entry['truncated'] == true) {
  //       //     if (forceTruncated) {
  //       //       entry['content'] = await AskNest(entry['raw_url']).get<String>();
  //       //     }
  //       //     entry['content'] = '';
  //       //   }
  //       //   return entry;
  //       // });
  //       // raw['description'] = src['description'];
  //       // raw['comments'] = src['comments'];
  //       // raw['id'] = src['id'];
  //       return GistListicleType.fromJSON(raw);
  //     },
  //   );
  // }
  // updateFile
  //  fileList listFile updateFile
  Future<GistListicleType> listFile() {
    return _ask.get<Map<String, dynamic>>(headers: header()).then<GistListicleType>(gistFileList);
  }

  GistListicleType gistFileList(Map<String, dynamic> res) {
    final src = res['body'];
    // gistId, dataId
    Map<String, dynamic> raw = {
      // 'gistId': src['id'],
      // 'dataId': token.id,
      'comments': src['comments'],
      'description': src['description'],
      'limit': res['x-ratelimit-limit'].first,
      'remaining': res['x-ratelimit-remaining'].first,
      'reset': res['x-ratelimit-reset'].first,
      'used': res['x-ratelimit-used'].first,
    };
    raw['files'] = src['files'].values;
    return GistListicleType.fromJSON(raw);
  }

  // void tmp() {
  //   _ask.get<HttpClientResponse>(headers: header()).then<GistListicleType>(
  //     (response) async{
  //       final res = await _ask.responseToString(response);
  //       final result = UtilDocument.decodeJSON<Map<String, dynamic>>(res);
  //       return GistListicleType.fromJSON({
  //         'gistId': result['id'],
  //         'dataId': token.id,
  //         'comments': result['comments'],
  //         'description': result['description'],
  //         'files': result['files'].values,
  //       });
  //     },
  //   );
  // }

  /// get list of Gist files
  /// ```dart
  /// final gist = GistData(repo:?);
  /// gist.gitFiles();
  /// ```
  Future<List<Map<String, dynamic>>> gitFiles() {
    return _ask.get<String>(headers: header()).then<List<Map<String, dynamic>>>(
      (res) {
        return UtilDocument.decodeJSON<Map<String, dynamic>>(res)['files']
            .values
            .map((entry) => {
                  'file': entry['filename'],
                  'type': entry['type'],
                  'language': entry['language'],
                  'url': entry['raw_url'],
                  'size': entry['size'],
                  'truncated': entry['truncated'],
                  'content': entry['truncated'] == true ? '' : entry['content'],
                })
            .toList()
            .cast<Map<String, dynamic>>();
      },
    );
  }

  /// Update or Create a file eg. fileContent: UtilDocument.encodeJSON({"test":true})
  /// ```dart
  /// final file = 'a/b.json'
  /// final content = UtilDocument.encodeJSON({"test":true})
  /// final gist = GistData(repo:?, token:'?');
  /// gist.updateFile(file:?, content:?);
  /// ```
  /// or
  /// ```dart
  /// final file = 'user.csv'
  /// final content = 'id,\nfirst,\nsecond,'
  /// final gist = GistData(repo:?);
  /// gist.token = '?';
  /// gist.updateFile(file:?, content:?);
  /// updateFile
  /// ```
  Future<T> updateFile<T>({String? file, required Object content}) {
    if (file == null && this.file != null) {
      file = this.file;
    }
    if (file != null && file.isNotEmpty) {
      return _ask.patch<T>(
        headers: header(),
        body: UtilDocument.encodeJSON<Object>(
          {
            'files': {
              file: {'content': content}
            }
          },
        ),
      );
    }
    return Future<T>.error('No identity');
  }

  /// Delete a file, token is required
  /// ```dart
  /// final name = 'a/b.json'
  /// final gist = GistData(repo:?, token:'?');
  /// gist.removeFile(fileName:?);
  /// ```
  /// or
  /// ```dart
  /// final gist = GistData(repo:?);
  /// gist.token = '?';
  /// gist.removeFile(name:?);
  /// ```
  Future<T> removeFile<T>({String? file}) async {
    if (file == null && this.file != null) {
      file = this.file;
    }
    if (file != null && file.isNotEmpty) {
      return _ask.patch<T>(
        headers: header(),
        body: UtilDocument.encodeJSON<Object>(
          {
            'files': {
              file: {'content': ''}
            }
          },
        ),
      );
    }
    return Future<T>.error('No identity');
  }

  // tmp: working
  Future<T> comment<T>({String? file, required Object content}) {
    final tmp = AskNest(urlGistBlock.replace(path: '/gists/${token.name}/comments'));
    // final tmp = AskNest(_ask.uri.replace(path: '/gists/$repo/comments'));
    if (file == null && this.file != null) {
      file = this.file;
    }
    // debugPrint(tmp.uri.toString());
    if (file != null && file.isNotEmpty) {
      return tmp.post<T>(
        headers: header(),
        body: UtilDocument.encodeJSON<Object>(
          {
            'gist_id': 'GIST_ID',
            'body': content,
          },
        ),
      );
    }
    return Future<T>.error('No identity');
  }
}
