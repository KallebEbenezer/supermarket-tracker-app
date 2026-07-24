// ignore_for_file: public_member_api_docs

import '../../domain/entities/sale_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class SaleMapper {
  /// Converte JSON bruto da API para [SaleEntity].
  SaleEntity fromJson(Map<String, dynamic> json) {
    return SaleEntity(
      id: json['id'] as String? ?? '',
      numero: json['numero'] as int? ?? 0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
      quantidadeItens: (json['quantidadeItens'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] as String? ?? '',
    );
  }

  /// Converte [SaleEntity] para JSON enviado ao backend.
  /// Payload mínimo; o create real usa FinalizarVendaRequest complexo
  /// passado como Map pelo repository.
  Map<String, dynamic> toJson(SaleEntity e) {
    return {
      'numero': e.numero,
      'total': e.total,
    };
  }

  /// Converte uma lista de JSONs para [SaleEntity].
  List<SaleEntity> fromJsonList(List<dynamic> list) {
    return list.map((j) => fromJson(j as Map<String, dynamic>)).toList();
  }
}
