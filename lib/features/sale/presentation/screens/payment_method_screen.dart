import 'package:flutter/material.dart' hide SnackBar, OutlinedButton, IconButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../providers/payment_provider.dart';
import '../providers/sale_providers.dart';

class PaymentMethodScreen extends ConsumerWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cart = ref.watch(paymentCartProvider);
    final cartNotifier = ref.read(paymentCartProvider.notifier);
    final saleTotal = cartNotifier.saleTotal;
    final remaining = cartNotifier.remaining;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentMethod)),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.md),
              children: [
                // Remaining amount
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  decoration: BoxDecoration(
                    color: remaining > 0 ? AppColors.warning.withValues(alpha: 0.1) : AppColors.success.withValues(alpha: 0.1),
                    borderRadius: AppRadii.medium,
                    border: Border.all(
                      color: remaining > 0 ? AppColors.warning : AppColors.success,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.remaining,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'R\$ ${remaining.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: remaining > 0 ? AppColors.warning : AppColors.success,
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),

                // Payment method buttons
                Text(
                  l10n.addPayment,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.sm),

                _PaymentMethodTile(
                  icon: Icons.qr_code,
                  label: l10n.paymentPix,
                  onTap: () => context.push('/sales/summary/payment-pix'),
                ),
                _PaymentMethodTile(
                  icon: Icons.credit_card,
                  label: l10n.paymentCard,
                  onTap: () => context.push('/sales/summary/payment-card'),
                ),
                _PaymentMethodTile(
                  icon: Icons.payments_outlined,
                  label: l10n.paymentCash,
                  onTap: () => context.push('/sales/summary/payment-cash'),
                ),

                // Added payments
                if (cart.payments.isNotEmpty) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    l10n.totalPaid,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ...cart.payments.asMap().entries.map((entry) {
                    final i = entry.key;
                    final payment = entry.value;
                    return ListTile(
                      leading: Icon(
                        payment.tipo == 'PIX'
                            ? Icons.qr_code
                            : payment.tipo == 'CARTAO'
                                ? Icons.credit_card
                                : Icons.payments_outlined,
                      ),
                      title: Text(payment.label),
                      subtitle: Text('R\$ ${payment.valor.toStringAsFixed(2)}'),
                      trailing: IconButton(
                        icon: const Icon(AppIcons.delete, size: 20),
                        onPressed: () => cartNotifier.removePayment(i),
                        tooltip: l10n.removePayment,
                      ),
                    );
                  }),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.subtotal,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'R\$ ${saleTotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.totalPaid,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      Text(
                        'R\$ ${cart.totalPaid.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.success,
                            ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.neutral95,
              border: Border(top: BorderSide(color: AppColors.neutral90)),
            ),
            child: SafeArea(
              child: PrimaryButton(
                label: cartNotifier.canFinalize
                    ? '${l10n.finishSale} • R\$ ${saleTotal.toStringAsFixed(2)}'
                    : '${l10n.remaining} R\$ ${remaining.toStringAsFixed(2)}',
                onPressed: cartNotifier.canFinalize ? () => context.pop() : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentMethodTile extends StatelessWidget {
  const _PaymentMethodTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
