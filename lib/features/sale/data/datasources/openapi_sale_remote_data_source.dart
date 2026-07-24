import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/sale_entity.dart';
import '../mappers/sale_mapper.dart';
import 'sale_remote_data_source.dart';

/// Implementação do [SaleRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiSaleRemoteDataSource implements SaleRemoteDataSource {
  OpenApiSaleRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final SaleMapper _mapper;

  @override
  Future<ApiEnvelope<SaleEntity>> finalizeSale(Map<String, dynamic> payload) =>
      _client.post(
        '/api/v1/vendas/finalizar',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<SaleEntity>> getSale(String saleId) => _client.get(
        '/api/v1/vendas/$saleId',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );
}
