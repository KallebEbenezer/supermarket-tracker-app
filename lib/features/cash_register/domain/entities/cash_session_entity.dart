// ignore_for_file: public_member_api_docs
// Campos espelhados de SessaoCaixaResponse (backend).

/// Entidade de domínio para Sessão de Caixa.
class CashSessionEntity {
  final String id;
  final String caixaId;
  final String status;
  final String abertoEm;
  final String fechadoEm;
  final double valorAbertura;
  final double valorFechamento;
  final String observacao;

  const CashSessionEntity({
    required this.id,
    required this.caixaId,
    required this.status,
    this.abertoEm = '',
    this.fechadoEm = '',
    required this.valorAbertura,
    this.valorFechamento = 0.0,
    this.observacao = '',
  });

  CashSessionEntity copyWith({
    String? id,
    String? caixaId,
    String? status,
    String? abertoEm,
    String? fechadoEm,
    double? valorAbertura,
    double? valorFechamento,
    String? observacao,
  }) {
    return CashSessionEntity(
      id: id ?? this.id,
      caixaId: caixaId ?? this.caixaId,
      status: status ?? this.status,
      abertoEm: abertoEm ?? this.abertoEm,
      fechadoEm: fechadoEm ?? this.fechadoEm,
      valorAbertura: valorAbertura ?? this.valorAbertura,
      valorFechamento: valorFechamento ?? this.valorFechamento,
      observacao: observacao ?? this.observacao,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CashSessionEntity && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CashSessionEntity(id: $id, status: $status)';
}
