// ignore_for_file: public_member_api_docs

// Campos espelhados de UsuarioResponse (backend).

/// Entidade de domínio para Usuário.
/// Imutável e livre de dependências externas.
class UserEntity {
  final String id;
  final String authUserId;
  final String nome;
  final String email;
  final String telefone;
  final String status;

  const UserEntity({
    required this.id,
    required this.authUserId,
    required this.nome,
    required this.email,
    required this.telefone,
    required this.status,
  });

  UserEntity copyWith({
    String? id,
    String? authUserId,
    String? nome,
    String? email,
    String? telefone,
    String? status,
  }) {
    return UserEntity(
      id: id ?? this.id,
      authUserId: authUserId ?? this.authUserId,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'UserEntity(id: $id, nome: $nome)';
}
