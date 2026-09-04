import 'package:flutter/material.dart' hide SnackBar, IconButton, OutlinedButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../domain/entities/sale_entity.dart';
import '../providers/payment_provider.dart';
import '../providers/sale_providers.dart';

class SaleSummaryScreen extends ConsumerStatefulWidget {
  const SaleSummaryScreen({super.key});

  @override
  ConsumerState<SaleSummaryScreen> createState() => _SaleSummaryScreenState();
}

class _SaleSummaryScreenState extends ConsumerState<SaleSummaryScreen> {
  bool _isFinalizing = false;

  Future<void> _finalizeSale() async {
    final l10n = AppLocalizations.of(context)!;
    final queue = ref.read(saleQueueProvider);
    final cart = ref.read(paymentCartProvider);
    final cartNotifier = ref.read(paymentCartProvider.notifier);
    final empresaId = ref.read(currentCompanyIdProvider) ?? '';
    final lojaId = ref.read(sessionManagerProvider).lojaId;
    final usuarioId =
        ref.read(sessionManagerProvider).currentUser?.id ?? '';
    final sessaoCaixaId = ref.read(sessionManagerProvider).sessaoCaixaId;

    if (!cartNotifier.canFinalize) {
      SnackBar.show(
        context,
        message: l10n.paymentIncomplete,
        type: SnackBarType.warning,
      );
      return;
    }

    // Bloqueia venda sem sessão de caixa aberta — backend retorna 500
    // genérico quando sessaoCaixaId é null/vazio.
    if (sessaoCaixaId == null || sessaoCaixaId.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.cashSessionRequired,
        type: SnackBarType.warning,
      );
      return;
    }

    setState(() => _isFinalizing = true);

    try {
      final payload = {
        'empresaId': empresaId,
        'lojaId': lojaId,
        'sessaoCaixaId': sessaoCaixaId,
        'usuarioId': usuarioId,
        'clienteId': null,
        'desconto': 0,
        'acrescimo': 0,
        'observacao': '',
        'itens': queue
            .asMap()
            .entries
            .map((entry) => entry.value.toRequestPayload(entry.key))
            .toList(),
        'pagamentos': cartNotifier.toPayloadList(),
      };

      final saleRepo = ref.read(saleRepositoryProvider);
      final sale = await saleRepo.finalizeSale(payload);

      if (!mounted) return;

      ref.read(saleQueueProvider.notifier).clear();
      ref.read(paymentCartProvider.notifier).clear();
      ref.invalidate(saleListProvider(empresaId));

      // Check if any payment is PIX
      final hasPixPayment = cart.payments.any((p) => p.tipo == 'PIX');
      if (hasPixPayment) {
        context.go('/sales/pix', extra: sale);
      } else {
        context.go('/sales/confirmation', extra: sale);
      }
    } on Object catch (e) {
      if (!mounted) return;
      final message = e is ServerException && e.traceId != null
          ? '${e.message}\nCód: ${e.traceId}'
          : e.toString();
      SnackBar.show(
        context,
        message: message,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _isFinalizing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final queue = ref.watch(saleQueueProvider);
    final cart = ref.watch(paymentCartProvider);
    final cartNotifier = ref.read(paymentCartProvider.notifier);
    final subtotal = ref.read(saleQueueProvider.notifier).subtotal;
    final remaining = cartNotifier.remaining;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.saleSummary),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(
                vertical: AppSpacing.sm,
                horizontal: AppSpacing.md,
              ),
              itemCount: queue.length,
              separatorBuilder: (_, __) => const AppDivider(),
              itemBuilder: (context, index) {
                final item = queue[index];
                return Dismissible(
                  key: ValueKey(item.productId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    color: AppColors.error,
                    child: Text(
                      l10n.removeItem,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  onDismissed: (_) {
                    ref.read(saleQueueProvider.notifier).removeItem(index);
                  },
                  child: ListTile(
                    title: Text(item.productName),
                    subtitle: Text(
                      '${item.quantity}x R\$ ${item.unitPrice.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, size: 20),
                          onPressed: () => ref
                              .read(saleQueueProvider.notifier)
                              .updateQuantity(index, item.quantity - 1),
                          tooltip: l10n.removeItem,
                        ),
                        Text(
                          '${item.quantity}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, size: 20),
                          onPressed: () => ref
                              .read(saleQueueProvider.notifier)
                              .updateQuantity(index, item.quantity + 1),
                          tooltip: l10n.removeItem,
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        Text(
                          'R\$ ${item.subtotal.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: const BoxDecoration(
              color: AppColors.neutral95,
              border: Border(
                top: BorderSide(color: AppColors.neutral90),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Subtotal / Total
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.subtotal, style: Theme.of(context).textTheme.bodyLarge),
                      Text('R\$ ${subtotal.toStringAsFixed(2)}', style: Theme.of(context).textTheme.bodyLarge),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.total,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'R\$ ${subtotal.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Payments section
                  if (cart.payments.isNotEmpty) ...[
                    const AppDivider(),
                    ...cart.payments.asMap().entries.map((entry) {
                      final i = entry.key;
                      final payment = entry.value;
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          payment.tipo == 'PIX'
                              ? Icons.qr_code
                              : payment.tipo == 'CARTAO'
                                  ? Icons.credit_card
                                  : Icons.payments_outlined,
                          size: 20,
                        ),
                        title: Text(payment.label),
                        subtitle: Text('R\$ ${payment.valor.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(AppIcons.delete, size: 18),
                          onPressed: () => cartNotifier.removePayment(i),
                          tooltip: l10n.removePayment,
                        ),
                      );
                    }),
                    const AppDivider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.totalPaid),
                        Text(
                          'R\$ ${cart.totalPaid.toStringAsFixed(2)}',
                          style: const TextStyle(color: AppColors.success),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.remaining),
                        Text(
                          'R\$ ${remaining.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: remaining > 0 ? AppColors.warning : AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: AppSpacing.md),

                  // Add payment button
                  OutlinedButton(
                    label: l10n.addPayment,
                    leadingIcon: const Icon(Icons.add, size: 18),
                    onPressed: () => context.push('/sales/summary/payment-method'),
                  ),
                  const SizedBox(height: AppSpacing.sm),

                  // Finalize button
                  PrimaryButton(
                    label: _isFinalizing
                        ? l10n.saleFinalizing
                        : '${l10n.finishSale} • R\$ ${subtotal.toStringAsFixed(2)}',
                    onPressed: (_isFinalizing || !cartNotifier.canFinalize)
                        ? null
                        : _finalizeSale,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
