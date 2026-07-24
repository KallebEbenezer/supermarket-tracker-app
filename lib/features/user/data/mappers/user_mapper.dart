import '../../domain/entities/user_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class UserMapper {
  /// Converte JSON bruto da API para [UserEntity].
  /// Parsing defensivo: tolera ausência de campos e tipos inesperados.
  UserEntity fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json['id'] as String? ?? '',
      authUserId: json['authUserId'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  /// Converte [UserEntity] para JSON enviado ao backend.
  Map<String, dynamic> toJson(UserEntity e) {
    return {
      'authUserId': e.authUserId,
      'nome': e.nome,
      'email': e.email,
      'telefone': e.telefone,
    };
  }

  /// Converte uma lista de JSONs para [UserEntity].
  List<UserEntity> fromJsonList(List<dynamic> list) {
    return list.map((j) => fromJson(j as Map<String, dynamic>)).toList();
  }
}
