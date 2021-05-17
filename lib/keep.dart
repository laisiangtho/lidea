// export 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KeepUser {
  Future<SharedPreferences> preferences = SharedPreferences.getInstance();

  Future<String?> getString(String key) async {
    try {
      SharedPreferences prefs = await preferences;
      return prefs.getString(key);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> setString(String key, String value) async {
    try {
      SharedPreferences prefs = await preferences;
      return prefs.setString(key, value);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<List<String>?> getStringList(String key) async {
    try {
      SharedPreferences prefs = await preferences;
      return prefs.getStringList(key);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> setStringList(String key, List<String> value) async {
    try {
      SharedPreferences prefs = await preferences;
      return prefs.setStringList(key, value);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<bool> exists(String key) async {
    SharedPreferences prefs = await preferences;
    return prefs.containsKey(key);
  }

  // setInt(), setDouble() & setBool(), getStringList(key)
  Future<Object?> get(String key) async {
    SharedPreferences prefs = await preferences;
    return prefs.get(key);
  }

  Future<Set<String>> get keys async {
    SharedPreferences prefs = await preferences;
    return prefs.getKeys();
  }
}