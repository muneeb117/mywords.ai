import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  final SharedPreferences preferences;

  StorageService({required this.preferences});

  Future<void> setString(String key, String value) async {
    await preferences.setString(key, value);
  }

  Future<void> setInt(String key, int value) async {
    await preferences.setInt(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await preferences.setBool(key, value);
  }

  bool getBool(String key) {
    return preferences.getBool(key) ?? false;
  }

  int getInt(String key) {
    return preferences.getInt(key) ?? 0;
  }

  bool getNotificationBool(String key) {
    return preferences.getBool(key) ?? true;
  }

  String? getString(String key) {
    return preferences.getString(key);
  }

  Future<void> remove(String key) async {
    await preferences.remove(key);
  }

  Future<bool> clear() async {
    return await preferences.clear();
  }
}
