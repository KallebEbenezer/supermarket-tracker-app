import 'package:flutter/foundation.dart';

import '../storage/secure_storage.dart';

class SessionManager {
  SessionManager(this._secureStorage);

  static const _accessTokenKey = 'session.access_token';
  final SecureStorage _secureStorage;
  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  Future<void> restore() async {
    isAuthenticated.value = await accessToken() != null;
  }

  Future<String?> accessToken() => _secureStorage.read(_accessTokenKey);

  Future<void> saveAccessToken(String token) async {
    await _secureStorage.write(_accessTokenKey, token);
    isAuthenticated.value = true;
  }

  Future<void> clear() async {
    await _secureStorage.delete(_accessTokenKey);
    isAuthenticated.value = false;
  }

  void dispose() => isAuthenticated.dispose();
}
