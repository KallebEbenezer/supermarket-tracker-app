import '../../domain/entities/stock_movement_entity.dart';

/// Mapper responsável por converter entre
/// JSON da API e entidades de domínio imutáveis.
class StockMovementMapper {
  /// Converte JSON bruto da API para [StockMovementEntity].
  StockMovementEntity fromJson(Map<String, dynamic> json) {
    return StockMovementEntity(
      id: json['id'] as String? ?? '',
      produtoId: json['produtoId'] as String? ?? '',
      tipo: json['tipo'] as String? ?? '',
      quantidade: (json['quantidade'] as num?)?.toDouble() ?? 0.0,
      estoqueAnterior: (json['estoqueAnterior'] as num?)?.toDouble() ?? 0.0,
      estoquePosterior: (json['estoquePosterior'] as num?)?.toDouble() ?? 0.0,
      criadoEm: json['criadoEm'] as String? ?? '',
    );
  }

  /// Converte [StockMovementEntity] para JSON enviado ao backend.
  Map<String, dynamic> toJson(StockMovementEntity e) {
    return {
      'produtoId': e.produtoId,
      'tipo': e.tipo,
      'quantidade': e.quantidade,
    };
  }

  /// Converte uma lista de JSONs para [StockMovementEntity].
  List<StockMovementEntity> fromJsonList(List<dynamic> list) {
    return list.map((j) => fromJson(j as Map<String, dynamic>)).toList();
  }
}
