import '../models/api_envelope.dart';
import '../models/api_json.dart';

/// Única porta remota permitida para os endpoints do backend v1.
abstract interface class SupermarketRemoteDataSource {
  Future<ApiEnvelope<Map<String, dynamic>>> createCompany(ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> createStore(ApiJson request);
  Future<ApiEnvelope<List<Map<String, dynamic>>>> listStores(String companyId);
  Future<ApiEnvelope<Map<String, dynamic>>> createProduct(ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> getProduct(String productId);
  Future<ApiEnvelope<Map<String, dynamic>>> createCustomer(ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> createUser(ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> createCashRegister(ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> openCashSession(String cashRegisterId, ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> closeCurrentCashSession(String cashRegisterId, ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> registerStockMovement(ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> finalizeSale(ApiJson request);
  Future<ApiEnvelope<Map<String, dynamic>>> getSale(String saleId);
  Future<ApiEnvelope<Map<String, dynamic>>> getDashboard({required String companyId, String? storeId, int limit = 10});
}
