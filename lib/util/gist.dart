part of '../engine.dart';

/// https://gist.github.com/[?]/[id]
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
  late final gitContentUri = Uri.https('gist.githubusercontent.com', '/owner/repo/raw/id/file');
  late final gitListUri = Uri.https('api.github.com', '/gists/repo');
  late final rawContentUri = Uri.https('raw.githubusercontent.com', '/owner/repo/master/file');

  late UtilClient _client;

  String owner;
  String repo;
  String? token;
  String? file;

  /// api.github.com/gists/repo
  /// create default client
  GistData({required this.owner, required this.repo, this.token, this.file}) {
    _client = UtilClient(gitListUri.replace(path: '/gists/$repo'));
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
  Future<T> gitContent<T>({String? owner, String? repo, String? file}) async {
    if (owner == null) {
      owner = this.owner;
    }
    if (repo == null) {
      repo = this.repo;
    }
    if (file == null && this.file != null) {
      file = this.file;
    }
    if (file != null && file.isNotEmpty) {
      return UtilClient(gitContentUri.replace(path: '/$owner/$repo/raw/$file')).get<T>();
    }
    return Future<T>.error("No identity");
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
  Future<T> rawContent<T>({String? owner, String? repo, String? file}) {
    if (owner == null) {
      owner = this.owner;
    }
    if (repo == null) {
      repo = this.repo;
    }
    if (file == null && this.file != null) {
      file = this.file;
    }
    if (file != null && file.isNotEmpty) {
      return UtilClient(rawContentUri.replace(path: '/$owner/$repo/master/$file')).get<T>();
    }
    return Future<T>.error("No identity");
  }

  Map<String, String> header({String? authorization}) {
    if (authorization != null) {
      token = authorization;
    }
    return {
      'Accept': 'application/vnd.github.v3+json',
      if (token != null) 'Authorization': 'token $token',
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
    return this.gitFiles().then((res) async {
      final List<String> result = [];
      final files = res.where((e) => e['type'] == "application/zip");
      for (var item in files) {
        if (item['truncated'] == false) {
          final bytes = await UtilDocument.strToListInt(item['content']);
          await UtilArchive().extract(bytes);
        } else {
          await UtilClient(item['url']).get<Uint8List>().then((res) {
            UtilArchive().extract(res).then((arc) {
              arc!.forEach((fileName) async {
                final isExists = await UtilDocument.exists(fileName);
                debugPrint('$fileName added: $isExists');
              });
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
  /// gist.gitFiles();
  /// ```
  Future<List<Map<String, dynamic>>> gitFiles() {
    return _client.get<String>().then<List<Map<String, dynamic>>>(
      (res) {
        return UtilDocument.decodeJSON<Map<String, dynamic>>(res)['files']
            .values
            .map((entry) => {
                  'file': entry['filename'],
                  'type': entry['type'],
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
  /// ```
  Future<T> updateFile<T>({String? file, required Object content}) {
    if (file == null && this.file != null) {
      file = this.file;
    }
    if (file != null && file.isNotEmpty) {
      return _client.patch<T>(
        headers: header(),
        body: UtilDocument.encodeJSON<Object>(
          {
            "files": {
              "$file": {"content": content}
            }
          },
        ),
      );
    }
    return Future<T>.error("No identity");
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
      return _client.patch<T>(
        headers: header(),
        body: UtilDocument.encodeJSON<Object>(
          {
            "files": {
              "$file": {"content": ""}
            }
          },
        ),
      );
    }
    return Future<T>.error("No identity");
  }
}
