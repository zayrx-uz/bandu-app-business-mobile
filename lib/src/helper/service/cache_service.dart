import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static SharedPreferences? preferences;

  static Future<void> init() async {
    preferences = await SharedPreferences.getInstance();
  }

  static void saveString(String key, String value) {
    preferences!.setString(key, value);
  }

  static void saveToken(String value) {
    preferences!.setString("access_token", value);
  }

  static String getToken() {
    return preferences!.getString("access_token") ?? '';
  }

  static void saveStringList(String key, List<String> value) {
    preferences!.setStringList(key, value);
  }

  static String getString(String key) {
    return preferences!.getString(key) ?? '';
  }

  static List<String> getStringList(String key) {
    return preferences!.getStringList(key) ?? [];
  }

  static void saveInt(String key, int value) {
    preferences!.setInt(key, value);
  }

  static int? getInt(String key) {
    return preferences!.getInt(key);
  }

  static void saveBool(String key, bool value) {
    preferences!.setBool(key, value);
  }

  static bool getBool(String key) {
    return preferences!.getBool(key) ?? false;
  }

  static void saveCategoryId(int categoryId) {
    preferences!.setInt("selected_category_id", categoryId);
  }

  static int? getCategoryId() {
    return preferences!.getInt("selected_category_id");
  }

  static void saveCategoryName(String categoryName) {
    preferences!.setString("selected_category_name", categoryName);
  }

  static String getCategoryName() {
    return preferences!.getString("selected_category_name") ?? '';
  }

  static void saveCategoryIkpuCode(String ikpuCode) {
    preferences!.setString("selected_category_ikpu_code", ikpuCode);
  }

  static String getCategoryIkpuCode() {
    return preferences!.getString("selected_category_ikpu_code") ?? '';
  }

  static Future<bool> clear() {
    return preferences!.clear();
  }
}
