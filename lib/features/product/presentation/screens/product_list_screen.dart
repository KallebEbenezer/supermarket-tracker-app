import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';

class ProductListScreen extends ConsumerWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider) ?? '';
    final products = ref.watch(productListProvider(empresaId));

    return AsyncScreen<List<ProductEntity>>(
      state: products,
      isEmpty: (list) => list.isEmpty,
      emptyMessage: l10n.noProducts,
      onRetry: () => ref.invalidate(productListProvider(empresaId)),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(productListProvider(empresaId)),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: list.length,
          separatorBuilder: (_, index) => const AppDivider(),
          itemBuilder: (context, index) {
            final product = list[index];
            return AppListTile(
              title: product.nome,
              subtitle:
                  '${product.codigoBarras} • R\$ ${product.precoVenda.toStringAsFixed(2)}',
              onTap: () => context.go('/products/${product.id}'),
            );
          },
        ),
      ),
    );
  }
}
