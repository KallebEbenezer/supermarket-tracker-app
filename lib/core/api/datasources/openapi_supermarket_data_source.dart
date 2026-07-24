import '../../network/api_client.dart';
import '../models/api_envelope.dart';
import '../models/api_json.dart';
import 'supermarket_remote_data_source.dart';

/// Implementação baseada no OpenAPI baixado de `/v3/api-docs`.
class OpenApiSupermarketDataSource implements SupermarketRemoteDataSource {
  OpenApiSupermarketDataSource(this._client);

  final ApiClient _client;

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> createCashRegister(ApiJson request) => _postMap('/api/v1/caixas', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> createCompany(ApiJson request) => _postMap('/api/v1/empresas', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> createCustomer(ApiJson request) => _postMap('/api/v1/clientes', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> createProduct(ApiJson request) => _postMap('/api/v1/produtos', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> createStore(ApiJson request) => _postMap('/api/v1/lojas', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> createUser(ApiJson request) => _postMap('/api/v1/usuarios', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> finalizeSale(ApiJson request) => _postMap('/api/v1/vendas/finalizar', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> getDashboard({required String companyId, String? storeId, int limit = 10}) => _getMap(
    '/api/v1/dashboard',
    queryParameters: {'empresaId': companyId, if (storeId != null) 'lojaId': storeId, 'limite': limit},
  );

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> getProduct(String productId) => _getMap('/api/v1/produtos/$productId');

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> getSale(String saleId) => _getMap('/api/v1/vendas/$saleId');

  @override
  Future<ApiEnvelope<List<Map<String, dynamic>>>> listStores(String companyId) => _client.get(
    '/api/v1/lojas',
    queryParameters: {'empresaId': companyId},
    parser: (data) => ApiEnvelope.fromJson(jsonObject(data), jsonObjectList),
  );

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> openCashSession(String cashRegisterId, ApiJson request) => _postMap('/api/v1/caixas/$cashRegisterId/sessoes', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> registerStockMovement(ApiJson request) => _postMap('/api/v1/estoque/movimentacoes', request);

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> closeCurrentCashSession(String cashRegisterId, ApiJson request) => _client.patch(
    '/api/v1/caixas/$cashRegisterId/sessoes/atual',
    data: request.toJson(),
    parser: (data) => ApiEnvelope.fromJson(jsonObject(data), jsonObject),
  );

  Future<ApiEnvelope<Map<String, dynamic>>> _getMap(String path, {Map<String, dynamic>? queryParameters}) => _client.get(
    path,
    queryParameters: queryParameters,
    parser: (data) => ApiEnvelope.fromJson(jsonObject(data), jsonObject),
  );

  Future<ApiEnvelope<Map<String, dynamic>>> _postMap(String path, ApiJson request) => _client.post(
    path,
    data: request.toJson(),
    parser: (data) => ApiEnvelope.fromJson(jsonObject(data), jsonObject),
  );
}
