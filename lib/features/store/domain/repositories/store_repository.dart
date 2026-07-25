import '../entities/store_entity.dart';

/// Contrato de domínio para operações de loja.
abstract class StoreRepository {
  Future<StoreEntity> getStore(String storeId);
  Future<List<StoreEntity>> listStores(String companyId, {int page = 0, int size = 20});
  Future<StoreEntity> createStore(Map<String, dynamic> payload);
}