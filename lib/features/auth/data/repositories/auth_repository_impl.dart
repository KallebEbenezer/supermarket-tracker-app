import 'package:supermarket_tracker_android/core/session/session_manager.dart';
import 'package:supermarket_tracker_android/features/auth/domain/entities/credentials.dart';
import 'package:supermarket_tracker_android/features/auth/domain/repositories/auth_repository.dart';
import 'package:supermarket_tracker_android/features/store/domain/repositories/store_repository.dart';

import '../datasources/auth_remote_data_source.dart';

/// Implementação de [AuthRepository] usando a fonte de dados remota e o
/// [SessionManager] para persistir a sessão.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._dataSource, this._sessionManager, this._storeRepository);

  final AuthRemoteDataSource _dataSource;
  final SessionManager _sessionManager;
  final StoreRepository _storeRepository;

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
  /// Também busca a primeira loja da empresa e seleciona como loja padrão.
  Future<void> _trySelectEmpresa(String userId) async {
    if (_sessionManager.empresaId != null) {
      // Já tem empresa, mas pode não ter lojaId — busca a primeira loja.
      if (_sessionManager.lojaId == null) {
        await _trySelectLoja(_sessionManager.empresaId!);
      }
      return;
    }
    try {
      final empresas = await _dataSource.listEmpresas(userId);
      if (empresas.isNotEmpty) {
        final empresaId = empresas.first['id'] as String;
        await _sessionManager.setEmpresaId(empresaId);
        await _trySelectLoja(empresaId);
      }
    } on Object {
      // Ignora — o usuário poderá criar empresa depois.
    }
  }

  /// Busca a primeira loja da empresa e seleciona como loja padrão.
  Future<void> _trySelectLoja(String empresaId) async {
    try {
      final lojas = await _storeRepository.listStores(empresaId, size: 1);
      if (lojas.isNotEmpty) {
        await _sessionManager.setLojaId(lojas.first.id);
      }
    } on Object {
      // Ignora — o usuário poderá criar loja depois.
    }
  }

  @override
  Future<AuthUser> me() async => (await _dataSource.me()).requireData();

  @override
  Future<void> ensureSessionContext() async {
    final user = _sessionManager.currentUser;
    if (user == null) return;
    if (_sessionManager.empresaId != null && _sessionManager.lojaId != null) {
      return;
    }
    await _trySelectEmpresa(user.id);
  }

  @override
  Future<void> solicitarReset(ForgotPasswordPayload payload) =>
      _dataSource.solicitarReset(payload.toJson());

  @override
  Future<void> redefinirSenha(ResetPasswordPayload payload) =>
      _dataSource.redefinirSenha(payload.toJson());
}
