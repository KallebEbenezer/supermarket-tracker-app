import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/cash_register_entity.dart';
import '../../domain/entities/cash_session_entity.dart';
import '../mappers/cash_register_mapper.dart';
import 'cash_register_remote_data_source.dart';

/// Implementação do [CashRegisterRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiCashRegisterRemoteDataSource implements CashRegisterRemoteDataSource {
  OpenApiCashRegisterRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final CashRegisterMapper _mapper;

  @override
  Future<ApiEnvelope<CashRegisterEntity>> createCashRegister(Map<String, dynamic> payload) =>
      _client.post(
        '/api/v1/caixas',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<List<CashRegisterEntity>>> listCashRegisters(String storeId) =>
      _client.get(
        '/api/v1/caixas',
        queryParameters: {'lojaId': storeId},
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonList(value as List<dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<CashSessionEntity>> openCashSession(
    String cashRegisterId,
    Map<String, dynamic> payload,
  ) =>
      _client.post(
        '/api/v1/caixas/$cashRegisterId/sessoes',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonSession(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<CashSessionEntity>> closeCurrentCashSession(
    String cashRegisterId,
    Map<String, dynamic> payload,
  ) =>
      _client.patch(
        '/api/v1/caixas/$cashRegisterId/sessoes/atual',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonSession(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<CashSessionEntity>> getCurrentCashSession(
    String cashRegisterId,
  ) =>
      _client.get(
        '/api/v1/caixas/$cashRegisterId/sessoes/atual',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonSession(value as Map<String, dynamic>),
        ),
      );
}
