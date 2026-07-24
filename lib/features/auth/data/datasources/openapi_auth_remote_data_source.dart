import 'package:supermarket_tracker_android/core/api/models/api_envelope.dart';
import 'package:supermarket_tracker_android/core/network/api_client.dart';
import 'package:supermarket_tracker_android/core/session/session_manager.dart';
import 'package:supermarket_tracker_android/features/auth/data/mappers/auth_mapper.dart';

import 'auth_remote_data_source.dart';

/// Implementação de [AuthRemoteDataSource] baseada na API do backend.
class OpenApiAuthRemoteDataSource implements AuthRemoteDataSource {
  OpenApiAuthRemoteDataSource(this._client, this._mapper);

  final ApiClient _client;
  final AuthMapper _mapper;

  @override
  Future<ApiEnvelope<AuthSession>> login(Map<String, dynamic> payload) => _client.post(
        '/api/v1/auth/login',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<AuthSession>> registro(Map<String, dynamic> payload) => _client.post(
        '/api/v1/auth/registro',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<AuthUser>> me() => _client.get(
        '/api/v1/auth/me',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.userFromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<void>> solicitarReset(Map<String, dynamic> payload) => _client.post(
        '/api/v1/auth/recuperar-senha',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (_) {},
        ),
      );

  @override
  Future<ApiEnvelope<void>> redefinirSenha(Map<String, dynamic> payload) => _client.post(
        '/api/v1/auth/redefinir-senha',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (_) {},
        ),
      );
}
