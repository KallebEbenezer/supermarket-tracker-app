import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SnackBar, OutlinedButton;
import 'package:flutter/material.dart' as material show SnackBar;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/entities/sale_entity.dart';
import '../providers/pix_payment_provider.dart';

class SalePixScreen extends ConsumerStatefulWidget {
  const SalePixScreen({super.key, required this.sale});

  final SaleEntity sale;

  @override
  ConsumerState<SalePixScreen> createState() => _SalePixScreenState();
}

class _SalePixScreenState extends ConsumerState<SalePixScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(pixPaymentProvider.notifier).startPayment(widget.sale.id);
    });
  }

  String _formatElapsed(Duration d) {
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  String _formatTimeRemaining(Duration d) {
    if (d.isNegative) return '00:00';
    final minutes = d.inMinutes.toString().padLeft(2, '0');
    final seconds = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pixState = ref.watch(pixPaymentProvider);

    if (pixState.status == PixPaymentStatus.approved) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          SnackBar.show(
            context,
            message: l10n.pixApproved,
            type: SnackBarType.success,
          );
          context.go('/sales');
        }
      });
    }

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.go('/sales');
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.pixQrCode),
          automaticallyImplyLeading: false,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // QR Code
                if (pixState.status == PixPaymentStatus.loading) ...[
                  const SizedBox(
                    width: 220,
                    height: 220,
                    child: Center(child: CircularProgressIndicator()),
                  ),
                ] else if (pixState.pixData != null &&
                    pixState.pixData!.copiaCola.isNotEmpty &&
                    pixState.status != PixPaymentStatus.error) ...[
                  // DEBUG: captura copia-cola via logcat para diagnosticar
                  // erro do banco "chave PIX inexistente". Remover após fix.
                  Builder(
                    builder: (_) {
                      debugPrint(
                        'PIX_DEBUG_COPIA_COLA=${pixState.pixData!.copiaCola}',
                      );
                      return const SizedBox.shrink();
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: AppRadii.medium,
                      boxShadow: AppShadows.level1,
                    ),
                    child: QrImageView(
                      data: pixState.pixData!.copiaCola,
                      version: QrVersions.auto,
                      size: 220,
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.neutral10,
                    ),
                  ),
                ] else if (pixState.pixData != null &&
                    pixState.pixData!.copiaCola.isEmpty) ...[
                  Icon(
                    Icons.error_outline,
                    color: AppColors.warning,
                    size: 48,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.pixQrCodeError,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.warning,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    label: l10n.retryPolling,
                    leadingIcon: const Icon(Icons.refresh, size: 18),
                    onPressed: () {
                      ref
                          .read(pixPaymentProvider.notifier)
                          .retry(widget.sale.id);
                    },
                  ),
                ],

                const SizedBox(height: AppSpacing.lg),

                // Sale info
                Text(
                  '${l10n.saleNumber}${widget.sale.numero}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'R\$ ${widget.sale.total.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  '${widget.sale.quantidadeItens.toStringAsFixed(0)} itens',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: AppSpacing.xl),

                // Status indicators
                if (pixState.status == PixPaymentStatus.waiting) ...[
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.pixWaiting,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    '${l10n.pollingElapsed} ${_formatElapsed(pixState.elapsed)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.neutral20,
                        ),
                  ),
                ],

                if (pixState.status == PixPaymentStatus.expired) ...[
                  Icon(
                    Icons.timer_off,
                    color: AppColors.error,
                    size: 32,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    l10n.pixTimeout,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    label: l10n.retryPolling,
                    leadingIcon: const Icon(Icons.refresh, size: 18),
                    onPressed: () {
                      ref
                          .read(pixPaymentProvider.notifier)
                          .retry(widget.sale.id);
                    },
                  ),
                ],

                if (pixState.status == PixPaymentStatus.error) ...[
                  Text(
                    pixState.errorMessage ?? 'Erro desconhecido',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.warning,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  OutlinedButton(
                    label: l10n.retryPolling,
                    leadingIcon: const Icon(Icons.refresh, size: 18),
                    onPressed: () {
                      ref
                          .read(pixPaymentProvider.notifier)
                          .retry(widget.sale.id);
                    },
                  ),
                ],

                const Spacer(),

                // Copy PIX code button
                if (pixState.pixData != null &&
                    pixState.pixData!.copiaCola.isNotEmpty) ...[
                  OutlinedButton(
                    label: l10n.copyPixCode,
                    leadingIcon: const Icon(Icons.copy, size: 18),
                    onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: pixState.pixData!.copiaCola));
                      ScaffoldMessenger.of(context).showSnackBar(
                        material.SnackBar(
                          content: Text(l10n.pixCodeCopied),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],

                // Close button
                PrimaryButton(
                  label: l10n.close,
                  leadingIcon: const Icon(Icons.check, size: 18),
                  onPressed: () {
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
}
