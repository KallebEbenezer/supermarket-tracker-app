// ignore_for_file: public_member_api_docs

// Campos espelhados de MovimentacaoEstoqueResponse (backend).

/// Entidade de domínio para Movimentação de Estoque.
/// Imutável e livre de dependências externas.
class StockMovementEntity {
  final String id;
  final String produtoId;
  final String tipo;
  final double quantidade;
  final double estoqueAnterior;
  final double estoquePosterior;
  final String criadoEm;

  const StockMovementEntity({
    required this.id,
    required this.produtoId,
    required this.tipo,
    required this.quantidade,
    required this.estoqueAnterior,
    required this.estoquePosterior,
    required this.criadoEm,
  });

  StockMovementEntity copyWith({
    String? id,
    String? produtoId,
    String? tipo,
    double? quantidade,
    double? estoqueAnterior,
    double? estoquePosterior,
    String? criadoEm,
  }) {
    return StockMovementEntity(
      id: id ?? this.id,
      produtoId: produtoId ?? this.produtoId,
      tipo: tipo ?? this.tipo,
      quantidade: quantidade ?? this.quantidade,
      estoqueAnterior: estoqueAnterior ?? this.estoqueAnterior,
      estoquePosterior: estoquePosterior ?? this.estoquePosterior,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StockMovementEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StockMovementEntity(id: $id, tipo: $tipo)';
}
