import 'package:supermarket_tracker_android/core/session/session_manager.dart';

/// Converte JSON da API de autenticação nas entidades de sessão.
class AuthMapper {
  const AuthMapper();

  AuthSession fromJson(Map<String, dynamic> json) {
    final usuario = (json['usuario'] as Map<String, dynamic>?) ?? <String, dynamic>{};
    return AuthSession(
      accessToken: (json['accessToken'] as String?) ?? '',
      refreshToken: (json['refreshToken'] as String?) ?? '',
      expiresAt: _expiresAtMillis(json['expiresInSegundos']),
      user: AuthUser(
        id: (usuario['id'] as String?) ?? '',
        nome: (usuario['nome'] as String?) ?? '',
        email: (usuario['email'] as String?) ?? '',
        papel: usuario['papel'] as String?,
      ),
      empresaId: json['empresaId'] as String?,
      lojaId: json['lojaId'] as String?,
    );
  }

  AuthUser userFromJson(Map<String, dynamic> json) => AuthUser(
        id: (json['id'] as String?) ?? '',
        nome: (json['nome'] as String?) ?? '',
        email: (json['email'] as String?) ?? '',
        papel: json['papel'] as String?,
      );

  int? _expiresAtMillis(dynamic segundos) {
    if (segundos == null) return null;
    final s = segundos is int ? segundos : int.tryParse(segundos.toString());
    if (s == null) return null;
    return DateTime.now().add(Duration(seconds: s)).millisecondsSinceEpoch;
  }
}
