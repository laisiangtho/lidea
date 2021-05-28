// export 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeepUser {
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  late String _kId = 'v100';

  KeepUser({String? key}) {
    this._kId = key??_kId;
  }

  String id(String? key) => key??_kId;

  Future<bool> exists({String? key}) async {
    // SharedPreferences prefs = await preferences;
    // return prefs.containsKey(key);
    return preferences.then(
      (e) => e.containsKey(id(key))
    );
  }

  Future<List<String>?> getList({String? key}) async {
    final tmp =  await SharedPreferences.getInstance();
    return tmp.getStringList(id(key));
    // return await preferences.then(
    //   (e) => e.getStringList(id(key))
    // );
  }

  Future<bool> setList({String? key, required List<String> value}) async {
    final tmp = await SharedPreferences.getInstance();
    return tmp.setStringList(id(key),value);
    // return await preferences.then(
    //   (e) => e.setStringList(id(key), value)
    // );
  }

  Future<String?> getStr({String? key}) async {
    return preferences.then(
      (e) => e.getString(id(key))
    );
  }

  Future<bool> setStr({String? key, required String value}) async {
    return preferences.then(
      (e) => e.setString(id(key), value)
    );
  }

  Future<int?> getInt({String? key}) async{
    return preferences.then(
      (e) => e.getInt(id(key))
    );
  }

  Future<bool> setInt({String? key, required int value}) async {
    return preferences.then(
      (e) => e.setInt(id(key), value)
    );
  }

  Future<bool?> getBool({String? key}) {
    return preferences.then(
      (e) => e.getBool(id(key))
    );
  }

  Future<bool> setBool({String? key, required bool value}) {
    return preferences.then(
      (e) => e.setBool(id(key), value)
    );
  }

  Future<double?> getDouble({String? key}) {
    return preferences.then(
      (e) => e.getDouble(id(key))
    );
  }

  Future<bool> setDouble({String? key, required double value}) {
    return preferences.then(
      (e) => e.setDouble(id(key), value)
    );
  }

  /// Returns all keys in the persistent storage.
  Future<Set<String>> get keys async {
    return preferences.then(
      (e) => e.getKeys()
    );
  }
}