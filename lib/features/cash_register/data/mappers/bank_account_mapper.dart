import '../../domain/entities/bank_account_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class BankAccountMapper {
  /// Converte JSON bruto da API para [BankAccountEntity].
  BankAccountEntity fromJson(Map<String, dynamic> json) {
    return BankAccountEntity(
      id: json['id'] as String? ?? '',
      empresaId: json['empresaId'] as String? ?? '',
      bancoCodigo: json['bancoCodigo'] as String? ?? '',
      bancoNome: json['bancoNome'] as String? ?? '',
      agencia: json['agencia'] as String? ?? '',
      conta: json['conta'] as String? ?? '',
      tipo: json['tipo'] as String? ?? 'CORRENTE',
      titularNome: json['titularNome'] as String? ?? '',
      titularDocumento: json['titularDocumento'] as String? ?? '',
      chavePix: json['chavePix'] as String? ?? '',
      principal: json['principal'] as bool? ?? false,
      status: json['status'] as String? ?? 'ATIVO',
    );
  }

  /// Converte [BankAccountEntity] para JSON enviado ao backend.
  Map<String, dynamic> toJson(BankAccountEntity e) {
    return {
      'empresaId': e.empresaId,
      'bancoCodigo': e.bancoCodigo,
      'bancoNome': e.bancoNome,
      'agencia': e.agencia,
      'conta': e.conta,
      'tipo': e.tipo,
      'titularNome': e.titularNome,
      'titularDocumento': e.titularDocumento,
      'chavePix': e.chavePix,
      'principal': e.principal,
    };
  }

  /// Converte uma lista de JSONs para [BankAccountEntity].
  List<BankAccountEntity> fromJsonList(List<dynamic> list) {
    return list
        .map((j) => fromJson(j as Map<String, dynamic>))
        .toList();
  }
}
