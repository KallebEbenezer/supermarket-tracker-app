import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/stock_movement_entity.dart';
import '../providers/stock_movement_providers.dart';

class StockMovementListScreen extends ConsumerWidget {
  const StockMovementListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider) ?? '';
    final movements =
        ref.watch(stockMovementListProvider(empresaId));

    return AsyncScreen<List<StockMovementEntity>>(
      state: movements,
      isEmpty: (list) => list.isEmpty,
      emptyMessage: l10n.noStockMovements,
      onRetry: () =>
          ref.invalidate(stockMovementListProvider(empresaId)),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(stockMovementListProvider(empresaId)),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: list.length,
          separatorBuilder: (_, index) => const AppDivider(),
          itemBuilder: (context, index) {
            final movement = list[index];
            return AppListTile(
              title: '${movement.tipo} • ${movement.quantidade.toStringAsFixed(3)}',
              subtitle:
                  'Estoque: ${movement.estoqueAnterior.toStringAsFixed(3)} → ${movement.estoquePosterior.toStringAsFixed(3)}',
            );
          },
        ),
      ),
    );
  }
}
