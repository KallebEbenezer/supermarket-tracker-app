import 'package:flutter/material.dart' hide SnackBar, OutlinedButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/entities/sale_entity.dart';
import '../providers/payment_provider.dart';
import '../providers/sale_providers.dart';

class SaleConfirmationScreen extends ConsumerWidget {
  const SaleConfirmationScreen({super.key, required this.sale});

  final SaleEntity sale;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cart = ref.watch(paymentCartProvider);

    final hasCash = cart.payments.any((p) => p.tipo == 'DINHEIRO');
    final hasPix = cart.payments.any((p) => p.tipo == 'PIX');
    final hasCard = cart.payments.any((p) => p.tipo == 'CARTAO');

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go('/sales');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.saleConfirmed),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: const BoxDecoration(
                    color: AppColors.success,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check, color: Colors.white, size: 48),
                ),
                const SizedBox(height: AppSpacing.lg),
                Text(
                  '${l10n.saleNumber}${sale.numero}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'R\$ ${sale.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Payment methods summary
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.paymentMethods,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        if (hasPix)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.qr_code, size: 20),
                            title: const Text('PIX'),
                            trailing: Text(
                              'R\$ ${cart.payments.where((p) => p.tipo == 'PIX').fold<double>(0, (s, p) => s + p.valor).toStringAsFixed(2)}',
                            ),
                          ),
                        if (hasCard)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.credit_card, size: 20),
                            title: const Text('Cartão'),
                            trailing: Text(
                              'R\$ ${cart.payments.where((p) => p.tipo == 'CARTAO').fold<double>(0, (s, p) => s + p.valor).toStringAsFixed(2)}',
                            ),
                          ),
                        if (hasCash)
                          ListTile(
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            leading: const Icon(Icons.payments_outlined, size: 20),
                            title: const Text('Dinheiro'),
                            trailing: Text(
                              'R\$ ${cart.payments.where((p) => p.tipo == 'DINHEIRO').fold<double>(0, (s, p) => s + p.valor).toStringAsFixed(2)}',
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                // Change if cash payment
                if (hasCash) ...[
                  const SizedBox(height: AppSpacing.md),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: AppRadii.medium,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          l10n.changeAmount,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          'R\$ ${_calculateChange(cart).toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.success,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppSpacing.xl),

                // Action buttons
                PrimaryButton(
                  label: l10n.newSale,
                  leadingIcon: const Icon(Icons.add_shopping_cart, size: 18),
                  onPressed: () {
                    ref.read(saleQueueProvider.notifier).clear();
                    ref.read(paymentCartProvider.notifier).clear();
                    context.go('/sales/scan');
                  },
                ),
                const SizedBox(height: AppSpacing.sm),
                OutlinedButton(
                  label: l10n.backToSales,
                  leadingIcon: const Icon(Icons.storefront, size: 18),
                  onPressed: () {
                    ref.read(saleQueueProvider.notifier).clear();
                    ref.read(paymentCartProvider.notifier).clear();
                    context.go('/sales');
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _calculateChange(PaymentCartState cart) {
    final cashPayments = cart.payments.where((p) => p.tipo == 'DINHEIRO');
    final totalCash = cashPayments.fold<double>(0, (s, p) => s + p.valor);
    final totalDue = cart.totalPaid;
    // Use the cash received minus what was needed for the remaining at time of payment
    // Simplified: change = total cash received - (sale total - other payments)
    final otherPayments =
        cart.payments.where((p) => p.tipo != 'DINHEIRO').fold<double>(0, (s, p) => s + p.valor);
    return totalCash - (cart.totalPaid - otherPayments);
  }
}
