import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<void> saveString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  static String? getString(String key) => _prefs?.getString(key);

  static Future<void> saveJson(String key, Map<String, dynamic> json) async {
    await _prefs?.setString(key, jsonEncode(json));
  }

  static Map<String, dynamic>? getJson(String key) {
    final str = _prefs?.getString(key);
    if (str == null) return null;
    return jsonDecode(str) as Map<String, dynamic>;
  }

  static Future<void> saveJsonList(String key, List<Map<String, dynamic>> list) async {
    await _prefs?.setString(key, jsonEncode(list));
  }

  static List<Map<String, dynamic>>? getJsonList(String key) {
    final str = _prefs?.getString(key);
    if (str == null) return null;
    return (jsonDecode(str) as List<dynamic>).cast<Map<String, dynamic>>();
  }

  static Future<void> remove(String key) async {
    await _prefs?.remove(key);
  }

  static Future<void> clear() async {
    await _prefs?.clear();
  }
}
