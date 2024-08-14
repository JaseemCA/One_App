import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static Future<void> saveValue(
      {required String key, required String value}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getSavedValue({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<bool> removedSavedValue({required String key}) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.remove(key);
  }
}
