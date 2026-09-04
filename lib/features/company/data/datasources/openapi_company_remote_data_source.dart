import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/company_entity.dart';
import '../mappers/company_mapper.dart';
import 'company_remote_data_source.dart';

/// Implementação do [CompanyRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiCompanyRemoteDataSource implements CompanyRemoteDataSource {
  OpenApiCompanyRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final CompanyMapper _mapper;

  @override
  Future<ApiEnvelope<CompanyEntity>> createCompany(Map<String, dynamic> payload) => _client.post(
        '/api/v1/empresas',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<List<CompanyEntity>>> listCompanies(String usuarioId) => _client.get(
        '/api/v1/empresas',
        queryParameters: {'usuarioId': usuarioId},
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => (value as List<dynamic>)
              .map((e) => _mapper.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
}
