part of 'main.dart';

class UtilArchive {
  /// Zip extract and return file names
  static Future<List<String>?> extract(List<int> bytes) async {
    // final data = await UtilDocument.loadBundleAsByte('word.sqlite');
    // final bytes = await UtilDocument.byteToListInt(data);
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      for (final file in archive) {
        if (file.isFile) {
          await UtilDocument.writeAsByte(file.name, file.content as List<int>, true);
        }
      }
      return archive.map((e) => e.name).toList();
    } catch (e) {
      return Future.error("Error", StackTrace.fromString(e.toString()));
    }
  }

  static Future<List<String>> extractBundle(String file) async {
    List<int>? bytes = await UtilDocument.loadBundleAsByte(file)
        .then((data) => UtilDocument.byteToListInt(data).catchError((_) => null))
        .catchError((e) => null);
    if (bytes != null && bytes.isNotEmpty) {
      final res = await UtilArchive.extract(bytes).catchError((_) => null);
      if (res != null) {
        return res;
      }
    }
    return Future.error("Failed to load");
  }
}
