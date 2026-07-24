import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Persistência local não sensível, adequada para preferências e cache leve.
class StorageService {
  StorageService() : _preferences = SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  Future<void> writeString(String key, String value) =>
      _preferences.setString(key, value);
  Future<String?> readString(String key) => _preferences.getString(key);
  Future<void> remove(String key) => _preferences.remove(key);
  Future<void> clear() => _preferences.clear();

  Future<void> writeJson(String key, Map<String, dynamic> value) =>
      writeString(key, jsonEncode(value));

  Future<Map<String, dynamic>?> readJson(String key) async {
    final value = await readString(key);
    return value == null
        ? null
        : Map<String, dynamic>.from(jsonDecode(value) as Map);
  }
}
