import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/product_entity.dart';
import '../mappers/product_mapper.dart';
import 'product_remote_data_source.dart';

/// Implementação do [ProductRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiProductRemoteDataSource implements ProductRemoteDataSource {
  OpenApiProductRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final ProductMapper _mapper;

  @override
  Future<ApiEnvelope<List<ProductEntity>>> listProducts(String companyId) =>
      _client.get(
        '/api/v1/produtos',
        queryParameters: {'empresaId': companyId},
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonList(value as List<dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<ProductEntity>> createProduct(Map<String, dynamic> payload) =>
      _client.post(
        '/api/v1/produtos',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<ProductEntity>> getProduct(String productId) => _client.get(
        '/api/v1/produtos/$productId',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<ProductEntity>> updateProduct(
    String id,
    Map<String, dynamic> payload,
  ) =>
      _client.put(
        '/api/v1/produtos/$id',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );
}
