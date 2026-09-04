class SaleQueueItem {
  final String productId;
  final String productName;
  final String barcode;
  final String unitMeasure;
  final double unitPrice;
  final double purchaseUnitPrice;
  final int quantity;

  const SaleQueueItem({
    required this.productId,
    required this.productName,
    required this.barcode,
    required this.unitMeasure,
    required this.unitPrice,
    required this.purchaseUnitPrice,
    required this.quantity,
  });

  double get subtotal => unitPrice * quantity;

  SaleQueueItem copyWith({
    String? productId,
    String? productName,
    String? barcode,
    String? unitMeasure,
    double? unitPrice,
    double? purchaseUnitPrice,
    int? quantity,
  }) {
    return SaleQueueItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      barcode: barcode ?? this.barcode,
      unitMeasure: unitMeasure ?? this.unitMeasure,
      unitPrice: unitPrice ?? this.unitPrice,
      purchaseUnitPrice: purchaseUnitPrice ?? this.purchaseUnitPrice,
      quantity: quantity ?? this.quantity,
    );
  }

  Map<String, dynamic> toRequestPayload(int index) => {
        'produtoId': productId,
        'numero': index + 1,
        'produtoNome': productName,
        'codigoBarras': barcode,
        'unidadeMedida': unitMeasure,
        'quantidade': quantity,
        'precoUnitario': unitPrice,
        'precoCompraUnitario': purchaseUnitPrice,
        'desconto': 0,
        'acrescimo': 0,
      };
}
