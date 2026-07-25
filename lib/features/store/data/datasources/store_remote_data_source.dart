import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/store_entity.dart';

/// Interface that defines the data‑source operations for stores.
abstract class StoreRemoteDataSource {
  /// Retrieve a single store by its ID.
  Future<ApiEnvelope<StoreEntity>> getStore(String storeId);

  /// List all stores belonging to a given company with pagination.
  Future<ApiEnvelope<List<StoreEntity>>> listStores(String companyId, {int page = 0, int size = 20});

  /// Create a new store.
  Future<ApiEnvelope<StoreEntity>> createStore(Map<String, dynamic> payload);
}