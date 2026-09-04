import 'package:supermarket_tracker_android/core/session/session_manager.dart';
import 'package:supermarket_tracker_android/features/auth/domain/entities/credentials.dart';

/// Contrato de autenticação da aplicação.
abstract interface class AuthRepository {
  /// Autentica e persiste a sessão (login).
  Future<AuthSession> login(LoginCredentials credentials);

  /// Registra um novo usuário e persiste a sessão.
  Future<AuthSession> registro(SignupPayload payload);

  /// Retorna o usuário autenticado atual (endpoint `/me`).
  Future<AuthUser> me();

  /// Garante que a sessão tenha empresa/loja selecionadas, buscando a primeira
  /// disponível quando estiverem ausentes (ex.: sessão restaurada de um login
  /// antigo, antes do auto-provisionamento). Usado na inicialização do app.
  Future<void> ensureSessionContext();

  /// Solicita a redefinição de senha pelo e-mail.
  Future<void> solicitarReset(ForgotPasswordPayload payload);

  /// Redefine a senha usando o token de recuperação.
  Future<void> redefinirSenha(ResetPasswordPayload payload);
}
