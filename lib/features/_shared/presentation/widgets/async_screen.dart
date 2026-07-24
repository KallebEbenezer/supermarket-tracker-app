import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';

/// Renderiza o estado de um [AsyncValue] usando os componentes de estado
/// do design system (loading / erro / vazio / dados).
///
/// Uso:
/// ```dart
/// AsyncScreen(
///   state: ref.watch(storeListProvider(companyId)),
///   isEmpty: (stores) => stores.isEmpty,
///   emptyMessage: l10n.noStores,
///   onRetry: () => ref.invalidate(storeListProvider(companyId)),
///   dataBuilder: (context, stores) => StoreList(stores),
/// );
/// ```
class AsyncScreen<T> extends ConsumerWidget {
  const AsyncScreen({
    super.key,
    required this.state,
    required this.dataBuilder,
    this.isEmpty,
    this.emptyMessage,
    this.emptyTitle,
    this.onRetry,
  });

  final AsyncValue<T> state;
  final Widget Function(BuildContext context, T data) dataBuilder;
  final bool Function(T data)? isEmpty;
  final String? emptyMessage;
  final String? emptyTitle;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context, WidgetRef ref) => switch (state) {
        AsyncLoading<T>() => const LoadingState(),
        AsyncError<T>(:final error) => ErrorState(
            message: _message(error),
            onRetry: onRetry,
          ),
        AsyncData<T>(:final value) =>
          isEmpty != null && isEmpty!(value)
              ? EmptyState(
                  title: emptyTitle ?? 'Nada por aqui',
                  message: emptyMessage ?? 'Não há dados para exibir.',
                )
              : dataBuilder(context, value),
      };

  static String _message(Object error) =>
      error is AppException ? error.message : 'Ocorreu um erro inesperado';
}
