import '../../domain/entities/customer_entity.dart';

class CustomerMapper {
  CustomerEntity fromJson(Map<String, dynamic> json) {
    return CustomerEntity(
      id: json['id'] as String? ?? '',
      empresaId: json['empresaId'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      cpfCnpj: json['cpfCnpj'] as String? ?? '',
      email: json['email'] as String? ?? '',
      telefone: json['telefone'] as String? ?? '',
      dataNascimento: json['dataNascimento'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson(CustomerEntity e) {
    return {
      'empresaId': e.empresaId,
      'nome': e.nome,
      'cpfCnpj': e.cpfCnpj,
      'email': e.email,
      'telefone': e.telefone,
      'dataNascimento': e.dataNascimento,
    };
  }

  List<CustomerEntity> fromJsonList(List<dynamic> list) {
    return list.map((j) => fromJson(j as Map<String, dynamic>)).toList();
  }
}
