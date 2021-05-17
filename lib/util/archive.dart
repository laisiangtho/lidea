part of '../engine.dart';

class UtilArchive {
  /// Zip extract and return file names
  Future<List<String>?> extract(List<int> bytes) async {
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
}
