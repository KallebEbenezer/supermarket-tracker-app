import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Cache de rede simples com TTL (time-to-live).
///
/// Armazena respostas de GET em SharedPreferences com um timestamp.
/// Quando a rede falha, o interceptor pode servir o cache se ainda válido.
class CacheService {
  CacheService() : _preferences = SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  static const _prefix = 'http_cache.';
  static const _tsSuffix = '.ts';

  /// Armazena uma resposta em cache com o timestamp atual.
  Future<void> put(String key, Map<String, dynamic> data) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    await _preferences.setString('$_prefix${key}_data', jsonEncode(data));
    await _preferences.setInt('$_prefix$key$_tsSuffix', now);
  }

  /// Recupera uma resposta do cache. Retorna `null` se não existir ou
  /// se o TTL (em minutos) foi expirado.
  Future<Map<String, dynamic>?> get(String key, {int ttlMinutes = 30}) async {
    final ts = await _preferences.getInt('$_prefix$key$_tsSuffix');
    if (ts == null) return null;
    final age = DateTime.now().millisecondsSinceEpoch - ts;
    if (age > ttlMinutes * 60 * 1000) {
      await _remove(key);
      return null;
    }
    final raw = await _preferences.getString('$_prefix${key}_data');
    if (raw == null) return null;
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  Future<void> _remove(String key) async {
    await _preferences.remove('$_prefix${key}_data');
    await _preferences.remove('$_prefix$key$_tsSuffix');
  }

  /// Limpa todo o cache HTTP.
  Future<void> clear() async {
    final keys = await _preferences.getKeys();
    for (final key in keys) {
      if (key.startsWith(_prefix)) {
        await _preferences.remove(key);
      }
    }
  }
}
