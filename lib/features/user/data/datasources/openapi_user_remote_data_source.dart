import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/user_entity.dart';
import '../mappers/user_mapper.dart';
import 'user_remote_data_source.dart';

/// Implementação do [UserRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiUserRemoteDataSource implements UserRemoteDataSource {
  OpenApiUserRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final UserMapper _mapper;

  @override
  Future<ApiEnvelope<UserEntity>> createUser(Map<String, dynamic> payload) => _client.post(
        '/api/v1/usuarios',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );
}
