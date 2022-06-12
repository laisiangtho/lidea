part of lidea.cluster;

class UtilDocument {
  // static String get assetsFolder => 'packages/dictionary/flutter/assets/';
  static const assetsFolder = 'assets';
  // static Future<void> abc() => WidgetsFlutterBinding.ensureInitialized();
  /// getApplicationDocumentsDirectory `Future<Directory> get directory async => await getApplicationDocumentsDirectory();`
  static Future<Directory> get directory => getApplicationDocumentsDirectory();

  static Future<String> fileName(String name) async {
    return join(await directory.then((e) => e.path), name);
  }

  // static Future<String> assets(String fileName) async => join(await directory.then((e) => e.path),assetsFolder, fileName);

  static Future<File> file(String name) async {
    return new File(await fileName(name));
  }

  // static Future<String> loadBundleAsString(String fileName) async => await rootBundle.loadString(join(assetsFolder,fileName));
  // static Future<ByteData> loadBundleAsByte(String fileName) async => rootBundle.load(join(assetsFolder,fileName));

  static String loadBundlePath(String name) {
    return join(assetsFolder, name);
  }

  static Future<String> loadBundleAsString(String name) async {
    try {
      return await rootBundle.loadString(join(assetsFolder, name));
    } catch (e) {
      // debugPrint('$e');
      return Future.error("Failed to load file");
    }
  }

  static Future<ByteData> loadBundleAsByte(String name) async {
    try {
      return await rootBundle.load(join(assetsFolder, name));
    } catch (e) {
      return Future.error("Failed to load file");
    }
  }

  static Future<List<int>?> byteToListInt(ByteData data) async {
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  static Future<List<int>> strToListInt(String data) async => utf8.encode(data);

  static Future<File> writeAsString(String name, String fileContext) async {
    return await file(name).then(
      (File e) async => await e.writeAsString(fileContext),
    );
  }

  static Future<File> writeAsByte(String name, List<int> bytes, bool flush) async {
    return await file(name).then(
      (File e) async => await e.writeAsBytes(bytes, flush: flush),
    );
  }

  static Future<String> readAsString(String name) async {
    return await file(name).then(
      (File e) async => await e.readAsString(),
    );
  }

  /// ```dart
  /// .readAsJSON<List<dynamic>>('file.json')
  /// .readAsJSON<Map<String, dynamic>>('file.json')
  /// ```
  static Future<T> readAsJSON<T>(String name) async {
    try {
      return decodeJSON<T>(
        await readAsString(name),
      );
    } catch (e) {
      return Future.error(e);
    }
  }
  // static Future<Uint8List> readAsByte(String fileName) async => await file(fileName).then(
  //   (File e) async => await e.readAsBytes()
  // );

  static Future<FileSystemEntity> delete(String name, {bool recursive = false}) async {
    return await file(name).then(
      (File e) async => await e.delete(recursive: recursive),
    );
  }

  /// NOTE: if exist return path basename, else return empty String
  static Future<String> exists(String name) async {
    return await file(name).then(
      (File e) async => await e.exists() ? basename(name) : '',
    );
  }

  static pathJoin(String a, String b) => join(a, b);

  /// JSON to Map
  static T decodeJSON<T>(String response) => json.decode(response);

  /// Map to JSON
  static String encodeJSON<T>(dynamic response) => json.encode(response);

  // CSV to JSON
  static Iterable<Map<String, String>> parseCSVSimple(String response) {
    List<String> rawSrc = response.split('\n');
    rawSrc.removeWhere((item) => item.isEmpty);

    List<String> header = rawSrc.removeAt(0).split(',');

    return rawSrc.map((o) {
      List<String> val = o.split(',');
      return val.asMap().map((idx, e) {
        return MapEntry(header.elementAt(idx), e);
      });
    });

    // final json = rawMap.map((e) => encodeJSON(e)).toList().toString();
    // return json;
  }
}

class UtilString {
  static bool stringCompare(String? a, String b) => a!.toLowerCase() == b.toLowerCase();

  static String screenName(String? str) {
    return str!.removeNonAlphanumeric().toTitleCase(joiner: '');
  }

  static String screenClass(String? str) {
    return str!.removeNonAlphanumeric().toTitleCase(joiner: '') + 'State';
  }
}

class UtilNumber {
  // NumberFormat.simpleCurrency(
  //       locale: localeName,
  //       name: '',
  //       decimalDigits: 0,
  //     ).format(i)

  static String simple(BuildContext context, int number) {
    // return NumberFormat.numberOfIntegerDigits(number).toString();
    return NumberFormat.simpleCurrency(
      // locale: localeName,
      locale: Localizations.localeOf(context).languageCode,
      name: '',
      decimalDigits: 0,
    ).format(number);
  }
}
