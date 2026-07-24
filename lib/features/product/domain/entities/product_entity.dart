// ignore_for_file: public_member_api_docs

// Campos espelhados de ProdutoDto (backend).

/// Entidade de domínio para Produto.
/// Imutável e livre de dependências externas.
class ProductEntity {
  final String id;
  final String empresaId;
  final String codigoBarras;
  final String nome;
  final double precoVenda;
  final double estoqueAtual;
  final String status;

  const ProductEntity({
    required this.id,
    required this.empresaId,
    required this.codigoBarras,
    required this.nome,
    required this.precoVenda,
    required this.estoqueAtual,
    required this.status,
  });

  ProductEntity copyWith({
    String? id,
    String? empresaId,
    String? codigoBarras,
    String? nome,
    double? precoVenda,
    double? estoqueAtual,
    String? status,
  }) {
    return ProductEntity(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      codigoBarras: codigoBarras ?? this.codigoBarras,
      nome: nome ?? this.nome,
      precoVenda: precoVenda ?? this.precoVenda,
      estoqueAtual: estoqueAtual ?? this.estoqueAtual,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ProductEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'ProductEntity(id: $id, nome: $nome)';
}
