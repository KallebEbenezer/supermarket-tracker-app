import 'package:supermarket_tracker_android/core/session/session_manager.dart';
import 'package:supermarket_tracker_android/features/auth/domain/entities/credentials.dart';
import 'package:supermarket_tracker_android/features/auth/domain/repositories/auth_repository.dart';

import '../datasources/auth_remote_data_source.dart';

/// Implementação de [AuthRepository] usando a fonte de dados remota e o
/// [SessionManager] para persistir a sessão.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, this._sessionManager);

  final AuthRemoteDataSource _dataSource;
  final SessionManager _sessionManager;

  @override
  Future<AuthSession> login(LoginCredentials credentials) async {
    final session = (await _dataSource.login(credentials.toJson())).requireData();
    await _sessionManager.saveSession(session);
    await _selectEmpresaLoja(session);
    return session;
  }

  @override
  Future<AuthSession> registro(SignupPayload payload) async {
    final session = (await _dataSource.registro(payload.toJson())).requireData();
    await _sessionManager.saveSession(session);
    await _selectEmpresaLoja(session);
    return session;
  }

  /// Seleciona a empresa/loja retornadas pelo backend (auto-provisionadas no
  /// registro/login). Como fallback para backends antigos sem esses campos,
  /// busca e seleciona a primeira empresa do usuário.
  Future<void> _selectEmpresaLoja(AuthSession session) async {
    if (session.empresaId != null && session.lojaId != null) {
      await _sessionManager.setEmpresaId(session.empresaId!);
      await _sessionManager.setLojaId(session.lojaId!);
      return;
    }
    await _trySelectEmpresa(session.user.id);
  }

  /// Busca as empresas do usuário e seleciona a primeira, se disponível.
  Future<void> _trySelectEmpresa(String userId) async {
    if (_sessionManager.empresaId != null) return;
    try {
      final empresas = await _dataSource.listEmpresas(userId);
      if (empresas.isNotEmpty) {
        await _sessionManager.setEmpresaId(empresas.first['id'] as String);
      }
    } on Object {
      // Ignora — o usuário poderá criar empresa depois.
    }
  }

  @override
  Future<AuthUser> me() async => (await _dataSource.me()).requireData();

  @override
  Future<void> solicitarReset(ForgotPasswordPayload payload) =>
      _dataSource.solicitarReset(payload.toJson());

  @override
  Future<void> redefinirSenha(ResetPasswordPayload payload) =>
      _dataSource.redefinirSenha(payload.toJson());
}
