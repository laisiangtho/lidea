part of lidea.nest;

class ArchiveNest {
  /// ZipDecoder
  static ZipDecoder get zip => ZipDecoder();

  /// TarDecoder
  static TarDecoder get tar => TarDecoder();

  /// BZip2Decoder
  static BZip2Decoder get bz => BZip2Decoder();

  /// GZipDecoder
  static GZipDecoder get gz => GZipDecoder();

  // *.csv    49
  // *.tsv    83 ??
  // *.tar
  // *.*.gz   31
  // *.*.bz2  66
  // *.zip    80
  // *.rar    82 ??
  // *.sqlite 83
  // *.json   123
  static List<int> available = [66, 80, 31];
  // 79+1 75 > PK 80 75
  static List<int> hack = [63, 80, 31];

  /// Zip extract and return file names, {String? pwd}
  static Future<List<String>?> extract(List<int> byte, {String? pwd}) async {
    // final data = await UtilDocument.loadBundleAsByte('word.sqlite');
    // final bytes = await UtilDocument.byteToListInt(data);

    try {
      final archive = ArchiveNest.decode(byte, pwd: pwd);
      for (var file in archive) {
        if (file.isFile) {
          debugPrint('file: ${file.name}');
          await UtilDocument.writeAsByte(file.name, file.content as List<int>, true);
          await file.close();
        }
      }
      archive.clear();
      return archive.map((e) => e.name).toList();
    } catch (e) {
      // return Future.error('Error', StackTrace.fromString(e.toString()));
      throw ArgumentError(e);
    }
  }

  // byteData.getUint8(byteData.offsetInBytes);
  static Archive decode(List<int> byte, {String? pwd}) {
    // var u8 = data.getUint8(data.offsetInBytes);
    // final byte = UtilDocument.byteToListInt(data);

    Archive();
    switch (byte.elementAt(0)) {
      case 66:
        return tar.decodeBytes(bz.decodeBytes(byte));
      case 80:
        return zip.decodeBytes(byte, password: pwd);
      case 31:
        return tar.decodeBytes(gz.decodeBytes(byte));
      default:
        throw ArgumentError('none archive');
    }
  }

  static Future<List<String>?> bundle(String file, {String? pwd}) async {
    debugPrint('bundle start');
    List<int>? byte = await UtilDocument.loadBundleAsListInt(file).catchError((e) {
      debugPrint('$e');
    });
    if (byte.isNotEmpty) {
      try {
        return await ArchiveNest.extract(byte);
      } catch (e) {
        debugPrint('12-0 $e');
        return await UtilDocument.writeAsByte(file, byte, true).then((_) => [file]);
      }
    }
    throw ArgumentError('LoadingBundleException');
  }

  // static Future<List<String>> bundle(String file, {String? pwd, bool zip = false}) async {
  //   List<int>? bytes = await UtilDocument.loadBundleAsByte(file)
  //       .then((e) => UtilDocument.byteToListInt(e).catchError((_) => null))
  //       .catchError((e) => null);
  //   if (bytes != null && bytes.isNotEmpty) {
  //     final res = await ArchiveNest.extract(bytes).catchError((_) => null);
  //     if (res == null) {
  //       if (zip) {
  //         return await UtilDocument.writeAsByte(file, bytes, true).then((value) {
  //           return [file];
  //         });
  //       }
  //       // throw ('ExtractingBundleException');
  //       throw ArgumentError('ExtractingBundleException');
  //     } else {
  //       return res;
  //     }
  //     // throw ('ExtractingBundleException');
  //   }
  //   // return Future.error("Extracting bundle failed");
  //   // throw ('LoadingBundleException');
  //   throw ArgumentError('LoadingBundleException');
  // }
}
