import '../storage/storage_service.dart';

class CacheService {
  CacheService(this._storage);

  final StorageService _storage;

  Future<void> put(String key, Map<String, dynamic> value) =>
      _storage.writeJson(key, value);
  Future<Map<String, dynamic>?> get(String key) => _storage.readJson(key);
  Future<void> remove(String key) => _storage.remove(key);
  Future<void> clear() => _storage.clear();
}
