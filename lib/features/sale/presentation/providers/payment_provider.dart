import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/payment_item.dart';
import 'sale_providers.dart';

class PaymentCartState {
  final List<PaymentItem> payments;

  const PaymentCartState({this.payments = const []});

  double get totalPaid => payments.fold(0, (sum, p) => sum + p.valor);
  bool get isEmpty => payments.isEmpty;
}

class PaymentCartNotifier extends Notifier<PaymentCartState> {
  @override
  PaymentCartState build() => const PaymentCartState();

  double get saleTotal =>
      ref.read(saleQueueProvider.notifier).subtotal;

  double get remaining => saleTotal - state.totalPaid;

  bool get canFinalize => remaining <= 0.001;

  void addPayment(PaymentItem item) {
    state = PaymentCartState(payments: [...state.payments, item]);
  }

  void removePayment(int index) {
    final newList = [...state.payments];
    newList.removeAt(index);
    state = PaymentCartState(payments: newList);
  }

  void clear() => state = const PaymentCartState();

  List<Map<String, dynamic>> toPayloadList() =>
      state.payments.map((p) => p.toPayload()).toList();
}

final paymentCartProvider =
    NotifierProvider<PaymentCartNotifier, PaymentCartState>(
  PaymentCartNotifier.new,
);
