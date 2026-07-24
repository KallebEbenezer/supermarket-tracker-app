import '../../domain/entities/cash_register_entity.dart';
import '../../domain/entities/cash_session_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class CashRegisterMapper {
  /// Converte JSON bruto da API para [CashRegisterEntity].
  CashRegisterEntity fromJson(Map<String, dynamic> json) {
    return CashRegisterEntity(
      id: json['id'] as String? ?? '',
      lojaId: json['lojaId'] as String? ?? '',
      codigo: json['codigo'] as String? ?? '',
      nome: json['nome'] as String? ?? '',
      status: json['status'] as String? ?? '',
    );
  }

  /// Converte JSON bruto da API para [CashSessionEntity].
  CashSessionEntity fromJsonSession(Map<String, dynamic> json) {
    return CashSessionEntity(
      id: json['id'] as String? ?? '',
      caixaId: json['caixaId'] as String? ?? '',
      status: json['status'] as String? ?? '',
      abertoEm: json['abertoEm'] as String? ?? '',
      fechadoEm: json['fechadoEm'] as String? ?? '',
      valorAbertura: (json['valorAbertura'] as num?)?.toDouble() ?? 0.0,
      valorFechamento: (json['valorFechamentoInformado'] as num?)?.toDouble() ?? 0.0,
      observacao: json['observacao'] as String? ?? '',
    );
  }

  /// Converte [CashRegisterEntity] para JSON enviado ao backend.
  Map<String, dynamic> toJson(CashRegisterEntity e) {
    return {
      'lojaId': e.lojaId,
      'codigo': e.codigo,
      'nome': e.nome,
    };
  }

  /// Converte uma lista de JSONs para [CashRegisterEntity].
  List<CashRegisterEntity> fromJsonList(List<dynamic> list) {
    return list.map((j) => fromJson(j as Map<String, dynamic>)).toList();
  }
}
