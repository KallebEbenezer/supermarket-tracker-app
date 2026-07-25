import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/constants.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/sale_entity.dart';
import '../providers/sale_providers.dart';

class SaleListScreen extends ConsumerWidget {
  const SaleListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final sales = ref.watch(saleListProvider(kDefaultCompanyId));

    return AsyncScreen<List<SaleEntity>>(
      state: sales,
      isEmpty: (list) => list.isEmpty,
      emptyMessage: l10n.noSales,
      onRetry: () => ref.invalidate(saleListProvider(kDefaultCompanyId)),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(saleListProvider(kDefaultCompanyId)),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: list.length,
          separatorBuilder: (_, index) => const AppDivider(),
          itemBuilder: (context, index) {
            final sale = list[index];
            return AppListTile(
              title: '#${sale.numero} • R\$ ${sale.total.toStringAsFixed(2)}',
              subtitle: '${sale.quantidadeItens.toStringAsFixed(0)} itens • ${sale.status}',
            );
          },
        ),
      ),
    );
  }
}
