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

  final SecureStorage _secureStorage;
  final ValueNotifier<bool> isAuthenticated = ValueNotifier(false);

  AuthSession? _session;

  /// Carrega a sessão persistida, se houver.
  Future<void> restore() async {
    final access = await _secureStorage.read(_kAccess);
    final refresh = await _secureStorage.read(_kRefresh);
    final expires = await _secureStorage.read(_kExpires);
    final userJson = await _secureStorage.read(_kUser);
    if (access != null && userJson != null) {
      _session = AuthSession(
        accessToken: access,
        refreshToken: refresh ?? '',
        expiresAt: expires == null ? null : int.tryParse(expires),
        user: AuthUser.fromJson(
          Map<String, dynamic>.from(jsonDecode(userJson) as Map),
        ),
      );
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
    await _secureStorage.delete(_kAccess);
    await _secureStorage.delete(_kRefresh);
    await _secureStorage.delete(_kExpires);
    await _secureStorage.delete(_kUser);
    isAuthenticated.value = false;
  }

  String? get accessToken => _session?.accessToken;
  String? get refreshToken => _session?.refreshToken;
  AuthUser? get currentUser => _session?.user;

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
