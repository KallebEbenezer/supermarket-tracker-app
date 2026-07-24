import '../entities/store_entity.dart';

/// Contrato de domínio para operações de loja.
abstract class StoreRepository {
  Future<StoreEntity> getStore(String storeId);
  Future<List<StoreEntity>> listStores(String companyId);
  Future<StoreEntity> createStore(Map<String, dynamic> payload);
}