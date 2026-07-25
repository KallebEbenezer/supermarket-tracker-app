import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/store_entity.dart';
import '../mappers/store_mapper.dart';
import 'store_remote_data_source.dart';

/// Implementação do [StoreRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiStoreRemoteDataSource implements StoreRemoteDataSource {
  OpenApiStoreRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final StoreMapper _mapper;

  @override
  Future<ApiEnvelope<StoreEntity>> getStore(String storeId) => _client.get(
        '/api/v1/lojas/$storeId',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<List<StoreEntity>>> listStores(String companyId, {int page = 0, int size = 20}) => _client.get(
        '/api/v1/lojas',
        queryParameters: {'empresaId': companyId, 'page': page, 'size': size},
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) {
            final paginated = value as Map<String, dynamic>;
            final items = paginated['data'] as List<dynamic>;
            return _mapper.fromJsonList(items);
          },
        ),
      );

  @override
  Future<ApiEnvelope<StoreEntity>> createStore(Map<String, dynamic> payload) => _client.post(
        '/api/v1/lojas',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );
}