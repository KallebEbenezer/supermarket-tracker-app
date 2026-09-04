import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supermarket_tracker_android/features/product/domain/entities/product_entity.dart';
import 'package:supermarket_tracker_android/features/sale/presentation/providers/sale_providers.dart';

void main() {
  late ProviderContainer container;
  late SaleQueueNotifier notifier;

  setUp(() {
    container = ProviderContainer();
    notifier = container.read(saleQueueProvider.notifier);
  });

  tearDown(() {
    container.dispose();
  });

  ProductEntity _product({
    required String id,
    String nome = 'Produto Teste',
    String codigoBarras = '7891234567890',
    double precoVenda = 10.0,
  }) {
    return ProductEntity(
      id: id,
      empresaId: 'empresa-1',
      codigoBarras: codigoBarras,
      nome: nome,
      precoVenda: precoVenda,
      estoqueAtual: 100,
      status: 'ATIVO',
    );
  }

  group('addItem deduplication', () {
    test('adds a new product and returns true', () {
      final product = _product(id: 'p1');
      final added = notifier.addItem(product);

      expect(added, isTrue);
      expect(container.read(saleQueueProvider).length, 1);
      expect(container.read(saleQueueProvider).first.productId, 'p1');
    });

    test('rejects duplicate product and returns false', () {
      final product = _product(id: 'p1');
      notifier.addItem(product);
      final addedAgain = notifier.addItem(product);

      expect(addedAgain, isFalse);
      expect(container.read(saleQueueProvider).length, 1);
    });

    test('allows different products to be added', () {
      final p1 = _product(id: 'p1', nome: 'Arroz');
      final p2 = _product(id: 'p2', nome: 'Feijão', codigoBarras: '999');

      notifier.addItem(p1);
      notifier.addItem(p2);

      expect(container.read(saleQueueProvider).length, 2);
    });

    test('does not increment quantity on duplicate scan', () {
      final product = _product(id: 'p1');
      notifier.addItem(product);
      notifier.addItem(product);

      final item = container.read(saleQueueProvider).first;
      expect(item.quantity, 1);
    });
  });

  group('removeItem and re-scan', () {
    test('allows re-scanning after item is removed', () {
      final product = _product(id: 'p1');
      notifier.addItem(product);
      expect(container.read(saleQueueProvider).length, 1);

      notifier.removeItem(0);
      expect(container.read(saleQueueProvider).length, 0);

      final addedAgain = notifier.addItem(product);
      expect(addedAgain, isTrue);
      expect(container.read(saleQueueProvider).length, 1);
    });

    test('removeItem does not affect other products', () {
      final p1 = _product(id: 'p1', nome: 'Arroz');
      final p2 = _product(id: 'p2', nome: 'Feijão', codigoBarras: '999');

      notifier.addItem(p1);
      notifier.addItem(p2);
      notifier.removeItem(0);

      expect(container.read(saleQueueProvider).length, 1);
      expect(container.read(saleQueueProvider).first.productId, 'p2');
    });
  });

  group('clear', () {
    test('clears all items and resets scanned tracking', () {
      final product = _product(id: 'p1');
      notifier.addItem(product);
      notifier.clear();

      expect(container.read(saleQueueProvider).isEmpty, isTrue);

      final added = notifier.addItem(product);
      expect(added, isTrue);
    });
  });

  group('subtotal calculation', () {
    test('calculates correct subtotal', () {
      notifier.addItem(_product(id: 'p1', precoVenda: 15.50));
      notifier.addItem(
        _product(id: 'p2', precoVenda: 25.00, codigoBarras: '999'),
      );

      expect(notifier.subtotal, closeTo(40.50, 0.01));
    });
  });

  group('edge cases', () {
    test('rejects product with empty id', () {
      final product = _product(id: '');
      final added = notifier.addItem(product);

      // Empty string id should still be tracked
      expect(added, isTrue);
      // Second scan with same empty id should be rejected
      final addedAgain = notifier.addItem(product);
      expect(addedAgain, isFalse);
    });

    test('removeItem at invalid index does not crash', () {
      notifier.removeItem(-1);
      notifier.removeItem(999);
      expect(container.read(saleQueueProvider).isEmpty, isTrue);
    });
  });

  group('simulated repeated scan', () {
    test('scanning same product 5 times results in 1 item', () {
      final product = _product(id: 'p1');

      for (var i = 0; i < 5; i++) {
        notifier.addItem(product);
      }

      expect(container.read(saleQueueProvider).length, 1);
      expect(container.read(saleQueueProvider).first.quantity, 1);
    });

    test('alternating products: scan p1, p2, p1, p2, p1', () {
      final p1 = _product(id: 'p1', nome: 'Arroz');
      final p2 = _product(id: 'p2', nome: 'Feijão', codigoBarras: '999');

      notifier.addItem(p1);
      notifier.addItem(p2);
      notifier.addItem(p1); // duplicate
      notifier.addItem(p2); // duplicate
      notifier.addItem(p1); // duplicate

      expect(container.read(saleQueueProvider).length, 2);
    });
  });
}
