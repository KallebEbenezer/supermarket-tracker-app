import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/stock_movement_entity.dart';
import '../mappers/stock_movement_mapper.dart';
import 'stock_movement_remote_data_source.dart';

/// Implementação do [StockMovementRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiStockMovementRemoteDataSource
    implements StockMovementRemoteDataSource {
  OpenApiStockMovementRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final StockMovementMapper _mapper;

  @override
  Future<ApiEnvelope<List<StockMovementEntity>>> listStockMovements(
    String companyId, {
    String? storeId,
  }) =>
      _client.get(
        '/api/v1/estoque/movimentacoes',
        queryParameters: {
          'empresaId': companyId,
          if (storeId != null) 'lojaId': storeId,
        },
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonList(value as List<dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<StockMovementEntity>> registerStockMovement(
    Map<String, dynamic> payload,
  ) =>
      _client.post(
        '/api/v1/estoque/movimentacoes',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );
}
