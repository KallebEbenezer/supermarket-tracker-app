import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../mappers/bank_account_mapper.dart';
import 'bank_account_remote_data_source.dart';

/// Implementação do [BankAccountRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiBankAccountRemoteDataSource
    implements BankAccountRemoteDataSource {
  OpenApiBankAccountRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final BankAccountMapper _mapper;

  @override
  Future<ApiEnvelope<List<BankAccountEntity>>> listBankAccounts(
    String empresaId,
  ) =>
      _client.get(
        '/api/v1/contas-bancarias',
        queryParameters: {'empresaId': empresaId},
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonList(value as List<dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<BankAccountEntity>> createBankAccount(
    Map<String, dynamic> payload,
  ) =>
      _client.post(
        '/api/v1/contas-bancarias',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<BankAccountEntity>> updateBankAccount(
    String id,
    Map<String, dynamic> payload,
  ) =>
      _client.put(
        '/api/v1/contas-bancarias/$id',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<void> deleteBankAccount(String id) => _client.delete(
        '/api/v1/contas-bancarias/$id',
      );
}
