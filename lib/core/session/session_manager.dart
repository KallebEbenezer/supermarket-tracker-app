import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../storage/secure_storage.dart';

/// Usuário autenticado exposto pela sessão (cabeçalho do app, telas, etc.).
class AuthUser {
  const AuthUser({
    required this.id,
    required this.nome,
    required this.email,
    this.papel,
  });

  final String id;
  final String nome;
  final String email;
  final String? papel;

  factory AuthUser.fromJson(Map<String, dynamic> json) => AuthUser(
        id: json['id'] as String? ?? '',
        nome: json['nome'] as String? ?? '',
        email: json['email'] as String? ?? '',
        papel: json['papel'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'email': email,
        'papel': papel,
      };
}

/// Sessão persistida: tokens de acesso/refresh, expiração e usuário.
class AuthSession {
  const AuthSession({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    this.expiresAt,
  });

  final String accessToken;
  final String refreshToken;
  final AuthUser user;

  /// Expiração do access token em milliseconds desde epoch.
  final int? expiresAt;

  AuthSession copyWith({
    String? accessToken,
    String? refreshToken,
    AuthUser? user,
    int? expiresAt,
  }) =>
      AuthSession(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        user: user ?? this.user,
        expiresAt: expiresAt ?? this.expiresAt,
      );
}

/// Gerencia a sessão do usuário com tokens JWT (access + refresh).
///
/// Armazena os tokens e o usuário de forma segura e mantém um [ValueNotifier]
/// de autenticação usado pelo roteador para o portão de sessão. O refresh
/// em 401 é tratado pelo [AuthInterceptor].
class SessionManager {
  SessionManager(this._secureStorage);

  static const _kAccess = 'session.accessToken';
  static const _kRefresh = 'session.refreshToken';
  static const _kExpires = 'session.expiresAt';
  static const _kUser = 'session.user';
  static const _kEmpresaId = 'session.empresaId';
  static const _kLojaId = 'session.lojaId';
  static const _kSessaoCaixaId = 'session.sessaoCaixaId';

  final SecureStorage _secureStorage;
  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);
  final ValueNotifier<bool> empresaIdChanged = ValueNotifier(false);
  final ValueNotifier<bool> lojaChanged = ValueNotifier(false);

  AuthSession? _session;
  String? _empresaId;
  String? _lojaId;
  String? _sessaoCaixaId;

  /// Carrega a sessão persistida, se houver.
  Future<void> restore() async {
    final access = await _secureStorage.read(_kAccess);
    final refresh = await _secureStorage.read(_kRefresh);
    final expires = await _secureStorage.read(_kExpires);
    final userJson = await _secureStorage.read(_kUser);
    final empresaId = await _secureStorage.read(_kEmpresaId);
    final lojaId = await _secureStorage.read(_kLojaId);
    final sessaoCaixaId = await _secureStorage.read(_kSessaoCaixaId);
    if (access != null && userJson != null) {
      _session = AuthSession(
        accessToken: access,
        refreshToken: refresh ?? '',
        expiresAt: expires == null ? null : int.tryParse(expires),
        user: AuthUser.fromJson(
          Map<String, dynamic>.from(jsonDecode(userJson) as Map),
        ),
      );
      _empresaId = empresaId;
      _lojaId = lojaId;
      _sessaoCaixaId = sessaoCaixaId;
      isAuthenticated.value = true;
    }
  }

  /// Persiste uma nova sessão (login/registro) e marca como autenticado.
  Future<void> saveSession(AuthSession session) async {
    _session = session;
    await _secureStorage.write(_kAccess, session.accessToken);
    await _secureStorage.write(_kRefresh, session.refreshToken);
    if (session.expiresAt != null) {
      await _secureStorage.write(_kExpires, session.expiresAt.toString());
    }
    await _secureStorage.write(_kUser, jsonEncode(session.user.toJson()));
    isAuthenticated.value = true;
  }

  /// Atualiza apenas o access token (após um refresh bem-sucedido).
  Future<void> updateAccessToken(String accessToken, [int? expiresAt]) async {
    _session = _session?.copyWith(
      accessToken: accessToken,
      expiresAt: expiresAt ?? _session?.expiresAt,
    );
    await _secureStorage.write(_kAccess, accessToken);
    if (expiresAt != null) {
      await _secureStorage.write(_kExpires, expiresAt.toString());
    }
  }

  /// Encerra a sessão (logout) e limpa os dados persistidos.
  Future<void> clear() async {
    _session = null;
    _empresaId = null;
    _lojaId = null;
    await _secureStorage.delete(_kAccess);
    await _secureStorage.delete(_kRefresh);
    await _secureStorage.delete(_kExpires);
    await _secureStorage.delete(_kUser);
    await _secureStorage.delete(_kEmpresaId);
    await _secureStorage.delete(_kLojaId);
    await _secureStorage.delete(_kSessaoCaixaId);
    _sessaoCaixaId = null;
    isAuthenticated.value = false;
  }

  String? get accessToken => _session?.accessToken;
  String? get refreshToken => _session?.refreshToken;
  AuthUser? get currentUser => _session?.user;
  String? get empresaId => _empresaId;
  String? get lojaId => _lojaId;
  String? get sessaoCaixaId => _sessaoCaixaId;

  /// Define e persiste a empresa selecionada.
  Future<void> setEmpresaId(String empresaId) async {
    _empresaId = empresaId;
    empresaIdChanged.value = !empresaIdChanged.value;
    await _secureStorage.write(_kEmpresaId, empresaId);
  }

  /// Define e persiste a loja selecionada.
  Future<void> setLojaId(String lojaId) async {
    _lojaId = lojaId;
    lojaChanged.value = !lojaChanged.value;
    await _secureStorage.write(_kLojaId, lojaId);
  }

  /// Define e persiste a sessão do caixa selecionada.
  Future<void> setSessaoCaixaId(String sessaoCaixaId) async {
    _sessaoCaixaId = sessaoCaixaId;
    await _secureStorage.write(_kSessaoCaixaId, sessaoCaixaId);
  }

  /// Cabeçalho `Authorization: Bearer <token>`, ou `null` se não houver sessão.
  String? bearerHeader() {
    final token = _session?.accessToken;
    return token == null || token.isEmpty ? null : 'Bearer $token';
  }

  /// Indica se há um access token ainda válido (não expirado).
  bool get hasValidAccessToken {
    final expires = _session?.expiresAt;
    if (expires == null) return _session != null;
    return DateTime.now().millisecondsSinceEpoch < expires;
  }
}
