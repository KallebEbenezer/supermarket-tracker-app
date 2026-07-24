import '../datasources/supermarket_remote_data_source.dart';
import '../models/api_envelope.dart';
import '../models/api_json.dart';

/// Fachada que futuras features devem injetar; elas nunca acessam Dio.
class SupermarketApiRepository {
  SupermarketApiRepository(this._remote);

  final SupermarketRemoteDataSource _remote;

  Future<ApiEnvelope<Map<String, dynamic>>> createCompany(ApiJson request) => _remote.createCompany(request);
  Future<ApiEnvelope<Map<String, dynamic>>> createStore(ApiJson request) => _remote.createStore(request);
  Future<ApiEnvelope<List<Map<String, dynamic>>>> listStores(String companyId) => _remote.listStores(companyId);
  Future<ApiEnvelope<Map<String, dynamic>>> createProduct(ApiJson request) => _remote.createProduct(request);
  Future<ApiEnvelope<Map<String, dynamic>>> getProduct(String productId) => _remote.getProduct(productId);
  Future<ApiEnvelope<Map<String, dynamic>>> createCustomer(ApiJson request) => _remote.createCustomer(request);
  Future<ApiEnvelope<Map<String, dynamic>>> createUser(ApiJson request) => _remote.createUser(request);
  Future<ApiEnvelope<Map<String, dynamic>>> createCashRegister(ApiJson request) => _remote.createCashRegister(request);
  Future<ApiEnvelope<Map<String, dynamic>>> openCashSession(String cashRegisterId, ApiJson request) => _remote.openCashSession(cashRegisterId, request);
  Future<ApiEnvelope<Map<String, dynamic>>> closeCurrentCashSession(String cashRegisterId, ApiJson request) => _remote.closeCurrentCashSession(cashRegisterId, request);
  Future<ApiEnvelope<Map<String, dynamic>>> registerStockMovement(ApiJson request) => _remote.registerStockMovement(request);
  Future<ApiEnvelope<Map<String, dynamic>>> finalizeSale(ApiJson request) => _remote.finalizeSale(request);
  Future<ApiEnvelope<Map<String, dynamic>>> getSale(String saleId) => _remote.getSale(saleId);
  Future<ApiEnvelope<Map<String, dynamic>>> getDashboard({required String companyId, String? storeId, int limit = 10}) => _remote.getDashboard(companyId: companyId, storeId: storeId, limit: limit);
}
