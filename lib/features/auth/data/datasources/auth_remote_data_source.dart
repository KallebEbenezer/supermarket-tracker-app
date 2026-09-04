import 'package:supermarket_tracker_android/core/api/models/api_envelope.dart';
import 'package:supermarket_tracker_android/core/session/session_manager.dart';

/// Fonte de dados remota de autenticação (contrato).
abstract interface class AuthRemoteDataSource {
  Future<ApiEnvelope<AuthSession>> login(Map<String, dynamic> payload);
  Future<ApiEnvelope<AuthSession>> registro(Map<String, dynamic> payload);
  Future<ApiEnvelope<AuthUser>> me();
  Future<ApiEnvelope<void>> solicitarReset(Map<String, dynamic> payload);
  Future<ApiEnvelope<void>> redefinirSenha(Map<String, dynamic> payload);
  Future<List<Map<String, dynamic>>> listEmpresas(String userId);
}
