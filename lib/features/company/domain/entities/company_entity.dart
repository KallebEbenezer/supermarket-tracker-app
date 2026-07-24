// ignore_for_file: public_member_api_docs

// Campos espelhados de EmpresaDto (backend).

/// Entidade de domínio para Empresa.
/// Imutável e livre de dependências externas.
class CompanyEntity {
  final String id;
  final String razaoSocial;
  final String nomeFantasia;
  final String cnpj;
  final String status;

  const CompanyEntity({
    required this.id,
    required this.razaoSocial,
    required this.nomeFantasia,
    required this.cnpj,
    this.status = '',
  });

  CompanyEntity copyWith({
    String? id,
    String? razaoSocial,
    String? nomeFantasia,
    String? cnpj,
    String? status,
  }) {
    return CompanyEntity(
      id: id ?? this.id,
      razaoSocial: razaoSocial ?? this.razaoSocial,
      nomeFantasia: nomeFantasia ?? this.nomeFantasia,
      cnpj: cnpj ?? this.cnpj,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CompanyEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CompanyEntity(id: $id, razaoSocial: $razaoSocial)';
}
