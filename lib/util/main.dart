import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io'
    show
        Directory,
        File,
        FileSystemEntity,
        HttpClientResponse,
        HttpClientRequest,
        HttpClient,
        SocketException;

import 'dart:typed_data';
// import 'dart:io' as io;
// import 'dart:math';
// import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show consolidateHttpClientResponseBytes;
import 'package:flutter/services.dart' show ByteData, PlatformException, rootBundle;

import 'package:path/path.dart' show join, basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:archive/archive.dart' show ZipDecoder;

part 'client.dart';
part 'archive.dart';
part 'gist.dart';

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
}
