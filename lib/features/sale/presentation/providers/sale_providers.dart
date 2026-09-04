import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/entities/sale_queue_item.dart';

final saleListProvider =
    FutureProvider.autoDispose.family<List<SaleEntity>, String>(
  (ref, companyId) =>
      ref.watch(saleRepositoryProvider).listSales(companyId),
);

final saleQueueProvider =
    NotifierProvider<SaleQueueNotifier, List<SaleQueueItem>>(
  SaleQueueNotifier.new,
);

class SaleQueueNotifier extends Notifier<List<SaleQueueItem>> {
  /// Produtos já escaneados nesta sessão de compra.
  /// Impede duplicatas mesmo após remoção do carrinho.
  final Set<String> _scannedProductIds = {};

  @override
  List<SaleQueueItem> build() => [];

  /// Tenta adicionar um produto ao carrinho.
  /// Retorna `true` se o produto foi adicionado, `false` se já foi escaneado.
  bool addItem(ProductEntity product) {
    if (_scannedProductIds.contains(product.id)) {
      return false;
    }

    _scannedProductIds.add(product.id);
    state = [
      ...state,
      SaleQueueItem(
        productId: product.id,
        productName: product.nome,
        barcode: product.codigoBarras,
        unitMeasure: 'UN',
        unitPrice: product.precoVenda,
        purchaseUnitPrice: 0,
        quantity: 1,
      ),
    ];
    return true;
  }

  void updateQuantity(int index, int newQuantity) {
    if (index < 0 || index >= state.length) return;
    if (newQuantity <= 0) {
      removeItem(index);
      return;
    }
    final item = state[index];
    state = [
      ...state.sublist(0, index),
      item.copyWith(quantity: newQuantity),
      ...state.sublist(index + 1),
    ];
  }

  void removeItem(int index) {
    if (index < 0 || index >= state.length) return;
    final removed = state[index];
    _scannedProductIds.remove(removed.productId);
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1),
    ];
  }

  void clear() {
    _scannedProductIds.clear();
    state = [];
  }

  double get subtotal =>
      state.fold(0, (sum, item) => sum + item.subtotal);

  int get itemCount => state.fold(0, (sum, item) => sum + item.quantity);
}

final finalizeSaleProvider =
    FutureProvider.autoDispose.family<SaleEntity, Map<String, dynamic>>(
  (ref, payload) =>
      ref.watch(saleRepositoryProvider).finalizeSale(payload),
);
