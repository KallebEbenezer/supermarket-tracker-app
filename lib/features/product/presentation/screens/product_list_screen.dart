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
    final empresaId = ref.watch(currentCompanyIdProvider);

    // Sem empresa — não é possível listar produtos (produto pertence a empresa).
    if (empresaId == null || empresaId.isEmpty) {
      return Center(
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
      );
    }

    final products = ref.watch(productListProvider(empresaId));

    return AsyncScreen<List<ProductEntity>>(
      state: products,
      isEmpty: (list) => list.isEmpty,
      emptyTitle: l10n.noProducts,
      emptyMessage: l10n.newProduct,
      onRetry: () => ref.invalidate(productListProvider(empresaId)),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(productListProvider(empresaId)),
        child: list.isEmpty
            ? _buildEmptyContent(context, l10n)
            : ListView.separated(
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

  Widget _buildEmptyContent(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.inventory_2_outlined, size: 48),
            const SizedBox(height: AppSpacing.md),
            Text(
              l10n.noProducts,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.newProduct,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            PrimaryButton(
              label: l10n.newProduct,
              leadingIcon: const Icon(Icons.add),
              onPressed: () => context.go('/products/new'),
            ),
          ],
        ),
      ),
    );
  }
}
