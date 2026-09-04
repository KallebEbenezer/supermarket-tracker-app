import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/product_entity.dart';
import '../providers/product_providers.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final product = ref.watch(productDetailProvider(productId));

    return AsyncScreen<ProductEntity>(
      state: product,
      onRetry: () => ref.invalidate(productDetailProvider(productId)),
      dataBuilder: (context, data) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                AppListTile(title: l10n.productName, subtitle: data.nome),
                const AppDivider(),
                AppListTile(
                    title: l10n.productBarcode, subtitle: data.codigoBarras),
                const AppDivider(),
                AppListTile(
                  title: l10n.productSalePrice,
                  subtitle: 'R\$ ${data.precoVenda.toStringAsFixed(2)}',
                ),
                const AppDivider(),
                AppListTile(
                  title: l10n.productCurrentStock,
                  subtitle: data.estoqueAtual.toStringAsFixed(3),
                ),
                const AppDivider(),
                AppListTile(title: l10n.productStatus, subtitle: data.status),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          PrimaryButton(
            label: l10n.editProduct,
            onPressed: () => context.go('/products/$productId/edit'),
          ),
        ],
      ),
    );
  }
}
