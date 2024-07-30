import 'package:shared_preferences/shared_preferences.dart';
import 'package:worbbing/repository/shared_preferences/shared_preferences_keys.dart';

class SharedPreferencesRepository {
  static late final SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> save<T>(SharedPreferencesKey key, T value) async {
    if (value is bool) {
      return _prefs.setBool(key.value, value);
    }
    if (value is String) {
      return _prefs.setString(key.value, value);
    }
    if (value is int) {
      return _prefs.setInt(key.value, value);
    }
    throw UnsupportedError('$Tタイプはサポートされていません');
  }

  T? fetch<T>(SharedPreferencesKey key) {
    if (T == bool) {
      return _prefs.getBool(key.value) as T?;
    }
    if (T == String) {
      return _prefs.getString(key.value) as T?;
    }
    if (T == int) {
      return _prefs.getInt(key.value) as T?;
    }
    throw UnsupportedError('$Tタイプはサポートされていません');
  }

  Future<bool> remove(SharedPreferencesKey key) => _prefs.remove(key.value);
}
