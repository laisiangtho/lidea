part of 'main.dart';

/// NOTE: only type, PollType child
/// raw['description'] = src['description'];
// raw['comments'] = src['comments'];
// raw['id'] = src['id'];
class GistFileListType {
  // final String gistId;
  // final String dataId;
  final List<GistFileItemType> files;
  final int comments;
  final String description;

  final String limit;
  final String remaining;
  final int reset;
  final String used;

  const GistFileListType({
    // this.gistId = '',
    // this.dataId = '',
    this.files = const [],
    this.comments = 0,
    this.description = '',
    this.limit = '',
    this.remaining = '',
    this.reset = 0,
    this.used = '',
  });

  factory GistFileListType.fromJSON(Map<String, dynamic> o) {
    return GistFileListType(
      // gistId: o['gistId'],
      // dataId: o['dataId'],
      files: (o['files'] ?? {})
          .map<GistFileItemType>((entry) => GistFileItemType.fromJSON(entry))
          .toList(),
      comments: o['comments'],
      description: o['description'],
      limit: o['limit'] ?? '',
      remaining: o['remaining'] ?? '',
      reset: int.parse((o['reset'] ?? 0)),
      // reset: (o['reset'] ?? 0) as int,
      used: o['used'] ?? '',
    );
  }

  /// MM/dd/yyyy, hh:mm a
  String get resetDatetime {
    return DateFormat('yyyy-MM-dd, HH:mm').format(
      DateTime.fromMillisecondsSinceEpoch(reset * 1000),
    );
  }
  // factory GistFileListType.fromString(String id, String res) {
  //   return GistFileListType(
  //     id: id,
  //     files: UtilDocument.decodeJSON<Map<String, dynamic>>(res)['files'].values.map(
  //       (entry) {
  //         return GistFileItemType.fromJSON(entry);
  //       },
  //     ).cast<GistFileItemType>(),
  //     // files: UtilDocument.decodeJSON<Map<String, dynamic>>(res)['files'].values.map(
  //     //   (entry) {
  //     //     return GistFileItemType.fromJSON(entry);
  //     //   },
  //     // ).cast<GistFileItemType>(),
  //   );
  // }

  String toJSON() {
    return UtilDocument.encodeJSON({
      // 'gistId': gistId,
      // 'dataId': dataId,
      'files': files.map((e) => e.toJSON()).toList(),
      'comments': comments,
      'description': description,
      'limit': limit,
      'remaining': remaining,
      'reset': reset.toString(),
      'used': used,
    });
  }

  /// save to local as JSON '$gistId.json'
  Future<void> save(String fileName) {
    return UtilDocument.writeAsString(fileName, toJSON());
  }
}

class GistFileItemType {
  final String file;
  final String type;
  final String language;
  // final String url;
  final int size;
  final bool truncated;
  String content;

  GistFileItemType({
    required this.file,
    required this.type,
    required this.language,
    // required this.url,
    this.size = 0,
    this.truncated = false,
    this.content = '',
  });

  factory GistFileItemType.fromJSON(Map<String, dynamic> o) {
    return GistFileItemType(
      file: o['filename'],
      type: o['type'],
      language: o['language'],
      // url: o['raw_url'],
      size: o['size'],
      truncated: o['truncated'],
      content: o['content'],
    );
  }

  // CSV to JSON
  Iterable<Map<String, dynamic>> parseCSV2JSON() {
    return UtilDocument.parseCSVSimple(content);
  }

  T parseContent2JSON<T>() {
    return UtilDocument.decodeJSON<T>(content);
  }

  Map<String, dynamic> toJSON() {
    return {
      'filename': file,
      'type': type,
      'language': language,
      // 'raw_url': url,
      'size': size,
      'truncated': truncated,
      'content': content,
    };
  }
}
