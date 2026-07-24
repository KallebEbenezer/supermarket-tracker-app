// ignore_for_file: public_member_api_docs
// Campos espelhados de LojaDto (backend).

/// Entidade de domínio para Loja.
/// Imutável e livre de dependências externas.
class StoreEntity {
  final String id;
  final String empresaId;
  final String codigo;
  final String nome;
  final String status;

  const StoreEntity({
    required this.id,
    required this.empresaId,
    required this.codigo,
    required this.nome,
    required this.status,
  });

  StoreEntity copyWith({
    String? id,
    String? empresaId,
    String? codigo,
    String? nome,
    String? status,
  }) {
    return StoreEntity(
      id: id ?? this.id,
      empresaId: empresaId ?? this.empresaId,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StoreEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'StoreEntity(id: $id, nome: $nome)';
}
