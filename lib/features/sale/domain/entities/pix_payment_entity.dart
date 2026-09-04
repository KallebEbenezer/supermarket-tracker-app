class PixPaymentEntity {
  const PixPaymentEntity({
    required this.qrCode,
    required this.copiaCola,
    required this.status,
    this.expiracao,
  });

  final String qrCode;
  final String copiaCola;
  final String status;
  final DateTime? expiracao;

  factory PixPaymentEntity.fromJson(Map<String, dynamic> json) {
    return PixPaymentEntity(
      qrCode: json['qrCode'] as String? ?? '',
      copiaCola: json['copiaCola'] as String? ?? '',
      status: json['status'] as String? ?? 'PENDENTE',
      expiracao: json['expiracao'] != null
          ? DateTime.tryParse(json['expiracao'] as String)
          : null,
    );
  }

  bool get isApproved => status.toUpperCase() == 'APROVADO';
  bool get isPending => status.toUpperCase() == 'PENDENTE';
  bool get isExpired => status.toUpperCase() == 'EXPIRADO' || status.toUpperCase() == 'REJEITADO';

  bool get isExpiredByTime {
    if (expiracao == null) return false;
    return DateTime.now().isAfter(expiracao!);
  }
}
