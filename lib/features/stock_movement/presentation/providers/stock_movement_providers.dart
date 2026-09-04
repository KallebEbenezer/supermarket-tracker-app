import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/stock_movement_entity.dart';

final stockMovementListProvider =
    FutureProvider.autoDispose.family<List<StockMovementEntity>, String>(
  (ref, companyId) =>
      ref.watch(stockMovementRepositoryProvider).listStockMovements(companyId),
);

/// Estado do formulário de criação de movimentação de estoque.
class StockMovementCreateState {
  const StockMovementCreateState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  StockMovementCreateState copyWith({bool? submitting, String? error}) =>
      StockMovementCreateState(
        submitting: submitting ?? this.submitting,
        error: error,
      );
}

final stockMovementCreateProvider =
    NotifierProvider<StockMovementCreateNotifier, StockMovementCreateState>(
  StockMovementCreateNotifier.new,
);

class StockMovementCreateNotifier extends Notifier<StockMovementCreateState> {
  @override
  StockMovementCreateState build() => const StockMovementCreateState();

  Future<StockMovementEntity> create(Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final created = await ref
          .read(stockMovementRepositoryProvider)
          .registerStockMovement(payload);
      state = state.copyWith(submitting: false);
      return created;
    } on Object catch (error) {
      final message = error is AppException
          ? error.message
          : 'Erro ao registrar movimentação';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}
