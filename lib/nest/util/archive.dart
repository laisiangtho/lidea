part of lidea.nest;

// ArchiveNest
class ArchiveNest {
  /// Zip extract and return file names
  static Future<List<String>?> extract(List<int> bytes) async {
    // final data = await UtilDocument.loadBundleAsByte('word.sqlite');
    // final bytes = await UtilDocument.byteToListInt(data);
    try {
      final archive = ZipDecoder().decodeBytes(bytes);
      for (var file in archive) {
        if (file.isFile) {
          await UtilDocument.writeAsByte(file.name, file.content as List<int>, true);
        }
      }
      return archive.map((e) => e.name).toList();
    } catch (e) {
      return Future.error("Error", StackTrace.fromString(e.toString()));
    }
  }

  static Future<List<String>> extractBundle(String file, {bool noneArchive = false}) async {
    List<int>? bytes = await UtilDocument.loadBundleAsByte(file)
        .then((data) => UtilDocument.byteToListInt(data).catchError((_) => null))
        .catchError((e) => null);
    if (bytes != null && bytes.isNotEmpty) {
      final res = await ArchiveNest.extract(bytes).catchError((_) => null);
      if (res == null) {
        if (noneArchive) {
          return await UtilDocument.writeAsByte(file, bytes, true).then((value) {
            return [file];
          });
        }
        throw ('ExtractingBundleException');
      } else {
        return res;
      }
      // throw ('ExtractingBundleException');
    }
    // return Future.error("Extracting bundle failed");
    throw ('LoadingBundleException');
  }
}
