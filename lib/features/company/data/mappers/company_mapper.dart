import '../../domain/entities/company_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class CompanyMapper {
  /// Converte JSON bruto da API para [CompanyEntity].
  CompanyEntity fromJson(Map<String, dynamic> json) {
    return CompanyEntity(
      id: json['id'] as String? ?? '',
      razaoSocial: json['razaoSocial'] as String? ?? '',
      nomeFantasia: json['nomeFantasia'] as String? ?? '',
      cnpj: json['cnpj'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  /// Converte [CompanyEntity] para JSON enviado ao backend
  /// (EmpresaRequest — id e status são gerados pelo servidor).
  Map<String, dynamic> toJson(CompanyEntity e) {
    return {
      'razaoSocial': e.razaoSocial,
      'nomeFantasia': e.nomeFantasia,
      'cnpj': e.cnpj,
    };
  }

  /// Converte uma lista de JSONs para [CompanyEntity].
  List<CompanyEntity> fromJsonList(List<dynamic> list) {
    return list.map((j) => fromJson(j as Map<String, dynamic>)).toList();
  }
}
