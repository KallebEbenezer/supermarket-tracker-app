// ignore_for_file: public_member_api_docs
// Campos espelhados de ClienteResponse (backend).

class CustomerEntity {
  final String id;
  final String empresaId;
  final String nome;
  final String cpfCnpj;
  final String email;
  final String telefone;
  final String dataNascimento;
  final String status;

  const CustomerEntity({
    required this.id,
    required this.empresaId,
    required this.nome,
    required this.cpfCnpj,
    required this.email,
    required this.telefone,
    required this.dataNascimento,
    required this.status,
  });

  CustomerEntity copyWith({
    String? id,
    String? empresaId,
    String? nome,
    String? cpfCnpj,
    String? email,
    String? telefone,
    String? dataNascimento,
    String? status,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      nome: nome ?? this.nome,
      cpfCnpj: cpfCnpj ?? this.cpfCnpj,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      dataNascimento: dataNascimento ?? this.dataNascimento,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CustomerEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CustomerEntity(id: $id, nome: $nome)';
}
