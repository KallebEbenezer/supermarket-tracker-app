import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../mappers/dashboard_mapper.dart';
import 'dashboard_remote_data_source.dart';

/// Implementação do [DashboardRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiDashboardRemoteDataSource implements DashboardRemoteDataSource {
  OpenApiDashboardRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final DashboardMapper _mapper;

  @override
  Future<ApiEnvelope<DashboardEntity>> getDashboard({
    required String companyId,
    String? storeId,
    int limit = 10,
  }) =>
      _client.get(
        '/api/v1/dashboard',
        queryParameters: {
          'empresaId': companyId,
          'lojaId': storeId,
          'limite': limit,
        },
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );
}
