// ignore_for_file: public_member_api_docs
// Campos espelhados de CaixaResponse (backend).

/// Entidade de domínio para Caixa.
class CashRegisterEntity {
  final String id;
  final String lojaId;
  final String codigo;
  final String nome;
  final String status;

  const CashRegisterEntity({
    required this.id,
    required this.lojaId,
    required this.codigo,
    required this.nome,
    required this.status,
  });

  CashRegisterEntity copyWith({
    String? id,
    String? lojaId,
    String? codigo,
    String? nome,
    String? status,
  }) {
    return CashRegisterEntity(
      id: id ?? this.id,
      lojaId: lojaId ?? this.lojaId,
      codigo: codigo ?? this.codigo,
      nome: nome ?? this.nome,
      status: status ?? this.status,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CashRegisterEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CashRegisterEntity(id: $id, nome: $nome)';
}
