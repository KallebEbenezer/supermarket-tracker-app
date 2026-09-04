class PaymentItem {
  final String tipo;
  final double valor;
  final String? modalidadeCartao;
  final int parcelas;
  final String? contaBancariaId;
  final String? referencia;

  const PaymentItem({
    required this.tipo,
    required this.valor,
    this.modalidadeCartao,
    this.parcelas = 1,
    this.contaBancariaId,
    this.referencia,
  });

  PaymentItem copyWith({
    String? tipo,
    double? valor,
    String? modalidadeCartao,
    int? parcelas,
    String? contaBancariaId,
    String? referencia,
  }) {
    return PaymentItem(
      tipo: tipo ?? this.tipo,
      valor: valor ?? this.valor,
      modalidadeCartao: modalidadeCartao ?? this.modalidadeCartao,
      parcelas: parcelas ?? this.parcelas,
      contaBancariaId: contaBancariaId ?? this.contaBancariaId,
      referencia: referencia ?? this.referencia,
    );
  }

  Map<String, dynamic> toPayload() => {
        'contaBancariaId': contaBancariaId,
        'tipo': tipo,
        'valor': valor,
        'modalidadeCartao': modalidadeCartao,
        'parcelas': parcelas,
        'referencia': referencia,
      };

  String get label {
    switch (tipo) {
      case 'PIX':
        return 'PIX';
      case 'CARTAO':
        final cardType = modalidadeCartao == 'CREDITO' ? 'Crédito' : 'Débito';
        return 'Cartão $cardType';
      case 'DINHEIRO':
        return 'Dinheiro';
      default:
        return tipo;
    }
  }
}
