import 'dart:convert' show json;
import 'dart:io' show Directory, File, FileSystemEntity;

// import 'dart:async';
// import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' show join, basename;
import 'package:path_provider/path_provider.dart' show getApplicationDocumentsDirectory;

import 'package:flutter/services.dart' show rootBundle, ByteData;

class UtilDocument {
  static String get assetsFolder => 'assets';
  // static Future<void> abc() => WidgetsFlutterBinding.ensureInitialized();
  /// getApplicationDocumentsDirectory `Future<Directory> get directory async => await getApplicationDocumentsDirectory();`
  static Future<Directory> get directory => getApplicationDocumentsDirectory();

  static Future<String> fileName(String fileName) async => join(await directory.then((e) => e.path), fileName);
  // static Future<String> assets(String fileName) async => join(await directory.then((e) => e.path),assetsFolder, fileName);

  static Future<File> file(String name) async => new File(await fileName(name));

  static Future<String> loadBundleAsString(String fileName) async => await rootBundle.loadString(join(assetsFolder,fileName));

  static Future<ByteData> loadBundleAsByte(String fileName) async => await rootBundle.load(join(assetsFolder,fileName));

  static Future<List<int>> byteToListInt(ByteData data) async => data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

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
  // Future<bool> docsExists(String fileName) async => await documents(fileName).then(
  //   (File e) async => await e.exists()
  // );

  /// JSON to Map
  // static Map<String, dynamic> decodeJSON(String response)  => json.decode(response);
  static dynamic decodeJSON(String response) => json.decode(response);

  /// Map to JSON
  // static String encodeJSON(Map<String, dynamic> response) => json.encode(response);
  static String encodeJSON(dynamic response) => json.encode(response);
}

class UtilClient {
  /// Request data over HTTP using get `...requestData(url).then().catchError()`
  static Future<String> request(String url) async {
    try {
      http.Response response = await http.get(Uri.parse(url));
      // return await http.read(url);
      if (response.statusCode == 200){
        return response.body;
      } else {
        return Future.error("Failed to load, code: ${response?.statusCode}");
      }
    } catch (e) {
      // print(e.message);
      return Future.error("No Internet", StackTrace.fromString(e.toString()));
    }
  }
  // getData postData

  // static Future<http.Response> get(String url) async => await http.get(Uri.parse(url));
  // static Future<http.Response> post(String url) async => await http.post(Uri.parse(url));
}
