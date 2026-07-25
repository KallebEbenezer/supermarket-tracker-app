import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/customer_entity.dart';
import '../mappers/customer_mapper.dart';
import 'customer_remote_data_source.dart';

/// Implementação do [CustomerRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiCustomerRemoteDataSource implements CustomerRemoteDataSource {
  OpenApiCustomerRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final CustomerMapper _mapper;

  @override
  Future<ApiEnvelope<List<CustomerEntity>>> listCustomers(String companyId) =>
      _client.get(
        '/api/v1/clientes',
        queryParameters: {'empresaId': companyId},
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonList(value as List<dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<CustomerEntity>> createCustomer(Map<String, dynamic> payload) => _client.post(
        '/api/v1/clientes',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );
}
