class PaymentEntity {
  const PaymentEntity({
    required this.id,
    required this.vendaId,
    required this.tipo,
    required this.valor,
    required this.status,
    this.referencia,
    this.recebidoEm,
  });

  final String id;
  final String vendaId;
  final String tipo;
  final double valor;
  final String status;
  final String? referencia;
  final DateTime? recebidoEm;

  factory PaymentEntity.fromJson(Map<String, dynamic> json) {
    return PaymentEntity(
      id: json['id'] as String,
      vendaId: json['vendaId'] as String,
      tipo: json['tipo'] as String,
      valor: (json['valor'] as num).toDouble(),
      status: json['status'] as String,
      referencia: json['referencia'] as String?,
      recebidoEm: json['recebidoEm'] != null
          ? DateTime.tryParse(json['recebidoEm'] as String)
          : null,
    );
  }
}
