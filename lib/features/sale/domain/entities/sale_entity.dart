// ignore_for_file: public_member_api_docs

// Campos espelhados de VendaDto (backend).

/// Entidade de domínio para Venda.
/// Imutável e livre de dependências externas.
class SaleEntity {
  final String id;
  final int numero;
  final double total;
  final double quantidadeItens;
  final String status;

  const SaleEntity({
    required this.id,
    this.numero = 0,
    required this.total,
    this.quantidadeItens = 0.0,
    required this.status,
  });

  SaleEntity copyWith({
    String? id,
    int? numero,
    double? total,
    double? quantidadeItens,
    String? status,
  }) {
    return SaleEntity(
      id: id ?? this.id,
      numero: numero ?? this.numero,
      total: total ?? this.total,
      quantidadeItens: quantidadeItens ?? this.quantidadeItens,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is SaleEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'SaleEntity(id: $id, numero: $numero)';
}
