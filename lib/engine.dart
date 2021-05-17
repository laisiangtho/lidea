import 'dart:async';
import 'dart:convert' show json, utf8;
import 'dart:io' show Directory, File, FileSystemEntity, HttpClientResponse, HttpClientRequest, HttpClient, SocketException;
import 'dart:typed_data';
// import 'dart:io' as io;
// import 'dart:math';
// import 'dart:async';

import 'package:flutter/foundation.dart' show consolidateHttpClientResponseBytes;
import 'package:flutter/services.dart' show ByteData, PlatformException, rootBundle;

import 'package:path/path.dart' show join, basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;
import 'package:archive/archive.dart' show ZipDecoder;

part 'util/client.dart';
part 'util/archive.dart';
part 'util/gist.dart';

class UtilDocument {
  // static String get assetsFolder => 'packages/dictionary/flutter/assets/';
  static String get assetsFolder => 'assets';
  // static Future<void> abc() => WidgetsFlutterBinding.ensureInitialized();
  /// getApplicationDocumentsDirectory `Future<Directory> get directory async => await getApplicationDocumentsDirectory();`
  static Future<Directory> get directory => getApplicationDocumentsDirectory();

  static Future<String> fileName(String fileName) async => join(await directory.then((e) => e.path), fileName);

  // static Future<String> assets(String fileName) async => join(await directory.then((e) => e.path),assetsFolder, fileName);

  static Future<File> file(String name) async => new File(await fileName(name));

  // static Future<String> loadBundleAsString(String fileName) async => await rootBundle.loadString(join(assetsFolder,fileName));
  // static Future<ByteData> loadBundleAsByte(String fileName) async => rootBundle.load(join(assetsFolder,fileName));
  
  static Future<String> loadBundleAsString(String fileName) async {
    try {
      return await rootBundle.loadString(join(assetsFolder,fileName));
    } catch (e) {
      return Future.error("Failed to load file");
    }
  }

  static Future<ByteData> loadBundleAsByte(String fileName) async {
    try {
      return await rootBundle.load(join(assetsFolder,fileName));
    } catch (e) {
      return Future.error("Failed to load file");
    }
  }

  static Future<List<int>?> byteToListInt(ByteData data) async => data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

  static Future<List<int>> strToListInt(String data) async => utf8.encode(data);

  static Future<File> writeAsString(String fileName, String fileContext) async => await file(fileName).then(
    (File e) async => await e.writeAsString(fileContext)
  );

  static Future<File> writeAsByte(String fileName, List<int> bytes, bool flush) async => await file(fileName).then(
    (File e) async => await e.writeAsBytes(bytes, flush: flush)
  );

  static Future<String> readAsString(String fileName) async => await file(fileName).then(
    (File e) async => await e.readAsString()
  );
  // static Future<Uint8List> readAsByte(String fileName) async => await file(fileName).then(
  //   (File e) async => await e.readAsBytes()
  // );

  static Future<FileSystemEntity> delete(String fileName) async => await file(fileName).then(
    (File e) async => await e.delete()
  );

  /// NOTE: if exist return path basename, else return empty String
  static Future<String> exists(String fileName) async => await file(fileName).then(
    (File e) async => await e.exists()?basename(fileName):''
  );

  static pathJoin(String a,String b) => join(a,b);

  /// JSON to Map
  static T decodeJSON<T>(String response) => json.decode(response);
  // static E decodeJSON<E, T>(String response) => json.decode(response);

  /// Map to JSON
  static String encodeJSON<T>(dynamic response) => json.encode(response);
}
