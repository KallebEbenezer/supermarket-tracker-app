import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/product_entity.dart';

final productListProvider =
    FutureProvider.autoDispose.family<List<ProductEntity>, String>(
  (ref, companyId) =>
      ref.watch(productRepositoryProvider).listProducts(companyId),
);

final productDetailProvider =
    FutureProvider.autoDispose.family<ProductEntity, String>(
  (ref, productId) =>
      ref.watch(productRepositoryProvider).getProduct(productId),
);

class ProductCreateState {
  const ProductCreateState({this.submitting = false, this.error});

  final bool submitting;
  final String? error;

  ProductCreateState copyWith({bool? submitting, String? error}) =>
      ProductCreateState(
        submitting: submitting ?? this.submitting,
        error: error,
      );
}

final productCreateProvider =
    NotifierProvider<ProductCreateNotifier, ProductCreateState>(
  ProductCreateNotifier.new,
);

class ProductCreateNotifier extends Notifier<ProductCreateState> {
  @override
  ProductCreateState build() => const ProductCreateState();

  Future<ProductEntity> create(Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final created =
          await ref.read(productRepositoryProvider).createProduct(payload);
      ref.invalidate(productListProvider);
      state = state.copyWith(submitting: false);
      return created;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao criar produto';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }

  Future<ProductEntity> update(String id, Map<String, dynamic> payload) async {
    state = state.copyWith(submitting: true, error: null);
    try {
      final updated =
          await ref.read(productRepositoryProvider).updateProduct(id, payload);
      ref.invalidate(productListProvider);
      ref.invalidate(productDetailProvider(id));
      state = state.copyWith(submitting: false);
      return updated;
    } on Object catch (error) {
      final message =
          error is AppException ? error.message : 'Erro ao atualizar produto';
      state = state.copyWith(submitting: false, error: message);
      rethrow;
    }
  }
}
