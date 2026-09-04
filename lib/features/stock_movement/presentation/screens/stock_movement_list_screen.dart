import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../../product/presentation/providers/product_providers.dart';
import '../../domain/entities/stock_movement_entity.dart';
import '../providers/stock_movement_providers.dart';

class StockMovementListScreen extends ConsumerWidget {
  const StockMovementListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider);

    // Sem empresa — não é possível listar movimentações (movimentação pertence a empresa).
    if (empresaId == null || empresaId.isEmpty) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(AppIcons.business, size: 64),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.noCompany,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.noCompanyMessage,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      );
    }

    final movements = ref.watch(stockMovementListProvider(empresaId));
    final productsAsync = ref.watch(productListProvider(empresaId));

    return Scaffold(
      body: AsyncScreen<List<StockMovementEntity>>(
        state: movements,
        isEmpty: (list) => list.isEmpty,
        emptyMessage: l10n.noStockMovements,
        onRetry: () =>
            ref.invalidate(stockMovementListProvider(empresaId)),
        dataBuilder: (context, list) => RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(stockMovementListProvider(empresaId)),
          child: productsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, __) => _buildList(context, list, {}, l10n),
            data: (products) {
              final productMap = {
                for (final p in products) p.id: p,
              };
              return _buildList(context, list, productMap, l10n);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildList(
    BuildContext context,
    List<StockMovementEntity> list,
    Map<String, ProductEntity> productMap,
    AppLocalizations l10n,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      itemCount: list.length,
      separatorBuilder: (_, index) => const AppDivider(),
      itemBuilder: (context, index) {
        final movement = list[index];
        final product = productMap[movement.produtoId];
        final productName = product?.nome ?? movement.produtoId;
        final tipoLabel = _tipoLabel(movement.tipo, l10n);
        final tipoColor = _tipoColor(movement.tipo);

        return AppListTile(
          title: productName,
          subtitle: '$tipoLabel \u2022 ${movement.quantidade.toStringAsFixed(3)}'
              '\nEstoque: ${movement.estoqueAnterior.toStringAsFixed(3)} \u2192 '
              '${movement.estoquePosterior.toStringAsFixed(3)}',
          leading: CircleAvatar(
            backgroundColor: tipoColor.withValues(alpha: 0.15),
            child: Icon(
              _tipoIcon(movement.tipo),
              color: tipoColor,
              size: 20,
            ),
          ),
          trailing: Text(
            _formatDate(movement.criadoEm),
            style: Theme.of(context).textTheme.bodySmall,
          ),
        );
      },
    );
  }

  String _tipoLabel(String tipo, AppLocalizations l10n) => switch (tipo) {
        'ENTRADA' => l10n.stockIn,
        'SAIDA' => l10n.stockOut,
        'VENDA' => l10n.stockSale,
        'AJUSTE' => l10n.stockAdjust,
        'CANCELAMENTO' => l10n.stockCancellation,
        _ => tipo,
      };

  Color _tipoColor(String tipo) => switch (tipo) {
        'ENTRADA' => Colors.green,
        'SAIDA' => Colors.red,
        'VENDA' => Colors.blue,
        'AJUSTE' => Colors.orange,
        'CANCELAMENTO' => Colors.grey,
        _ => Colors.blueGrey,
      };

  IconData _tipoIcon(String tipo) => switch (tipo) {
        'ENTRADA' => Icons.arrow_downward,
        'SAIDA' => Icons.arrow_upward,
        'VENDA' => Icons.shopping_cart,
        'AJUSTE' => Icons.tune,
        'CANCELAMENTO' => Icons.cancel,
        _ => Icons.help_outline,
      };

  String _formatDate(String criadoEm) {
    try {
      final date = DateTime.parse(criadoEm);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (_) {
      return criadoEm;
    }
  }
}
