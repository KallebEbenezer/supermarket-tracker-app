import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/customer_entity.dart';

final customerListProvider =
    FutureProvider.autoDispose.family<List<CustomerEntity>, String>(
  (ref, companyId) =>
      ref.watch(customerRepositoryProvider).listCustomers(companyId),
);

class CustomerCreateState {
  const CustomerCreateState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  CustomerCreateState copyWith({bool? submitting, String? error}) =>
      CustomerCreateState(
        submitting: submitting ?? this.submitting,
        error: error,
      );
}

final customerCreateProvider =
    NotifierProvider<CustomerCreateNotifier, CustomerCreateState>(
  CustomerCreateNotifier.new,
);

class CustomerCreateNotifier extends Notifier<CustomerCreateState> {
  @override
  CustomerCreateState build() => const CustomerCreateState();

  Future<CustomerEntity> create(Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final created =
          await ref.read(customerRepositoryProvider).createCustomer(payload);
      ref.invalidate(customerListProvider);
      state = state.copyWith(submitting: false);
      return created;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao criar cliente';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}
