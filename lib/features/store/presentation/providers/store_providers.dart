import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/store_entity.dart';

final storeListProvider = FutureProvider.autoDispose.family<List<StoreEntity>, String>(
  (ref, companyId) => ref.watch(storeRepositoryProvider).listStores(companyId),
);

final storeDetailProvider = FutureProvider.autoDispose.family<StoreEntity, String>(
  (ref, storeId) => ref.watch(storeRepositoryProvider).getStore(storeId),
);

/// Estado do formulário de criação de loja.
class StoreCreateState {
  const StoreCreateState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  StoreCreateState copyWith({bool? submitting, String? error}) => StoreCreateState(
        submitting: submitting ?? this.submitting,
        error: error,
      );
}

/// Notifier responsável por criar uma loja e invalidar a lista em seguida.
final storeCreateProvider =
    NotifierProvider<StoreCreateNotifier, StoreCreateState>(
  StoreCreateNotifier.new,
);

class StoreCreateNotifier extends Notifier<StoreCreateState> {
  @override
  StoreCreateState build() => const StoreCreateState();

  Future<StoreEntity> create(Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final created = await ref.read(storeRepositoryProvider).createStore(payload);
      // Invalida todos os providers de loja para forçar reload
      ref.invalidate(storeListProvider);
      ref.invalidate(storeDetailProvider);
      state = state.copyWith(submitting: false);
      return created;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao criar loja';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}
