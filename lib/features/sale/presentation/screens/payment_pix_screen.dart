import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide SnackBar, IconButton, OutlinedButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../cash_register/presentation/providers/bank_account_provider.dart';
import '../../domain/entities/payment_item.dart';
import '../providers/payment_provider.dart';

class PaymentPixScreen extends ConsumerStatefulWidget {
  const PaymentPixScreen({super.key});

  @override
  ConsumerState<PaymentPixScreen> createState() => _PaymentPixScreenState();
}

class _PaymentPixScreenState extends ConsumerState<PaymentPixScreen> {
  late final TextEditingController _amountController;
  String? _selectedContaBancariaId;
  String? _selectedContaBancariaChavePix;

  @override
  void initState() {
    super.initState();
    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    _amountController = TextEditingController(text: remaining.toStringAsFixed(2));
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _addPixPayment() {
    final l10n = AppLocalizations.of(context)!;
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) return;

    if (_selectedContaBancariaId == null) {
      SnackBar.show(
        context,
        message: l10n.bankAccountRequired,
        type: SnackBarType.warning,
      );
      return;
    }

    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    final effectiveAmount = amount > remaining ? remaining : amount;

    // DEBUG: captura payload enviado para diagnosticar "chave PIX inexistente".
    // Remover após confirmar que o backend usa a contaBancariaId correta.
    debugPrint(
      'PIX_DEBUG_PAYLOAD '
      'contaBancariaId=$_selectedContaBancariaId '
      'chavePix=$_selectedContaBancariaChavePix '
      'valor=$effectiveAmount',
    );

    ref.read(paymentCartProvider.notifier).addPayment(
          PaymentItem(
            tipo: 'PIX',
            valor: effectiveAmount,
            contaBancariaId: _selectedContaBancariaId,
          ),
        );

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    final empresaId = ref.read(sessionManagerProvider).empresaId ?? '';
    final bankAccounts = ref.watch(bankAccountListProvider(empresaId));

    // Auto-select: prioriza conta marcada como principal; se não houver,
    // cai pra primeira conta ativa. Nunca deixa null se houver conta
    // disponível — evita enviar contaBancariaId=null pro backend.
    if (_selectedContaBancariaId == null) {
      bankAccounts.whenData((accounts) {
        if (!mounted || accounts.isEmpty) return;
        final principal =
            accounts.where((a) => a.principal).firstOrNull ?? accounts.first;
        setState(() {
          _selectedContaBancariaId = principal.id;
          _selectedContaBancariaChavePix = principal.chavePix;
        });
      });
    }

    final accountsList = bankAccounts.asData?.value ?? const [];
    final noAccounts = bankAccounts.maybeWhen(
      data: (a) => a.isEmpty,
      orElse: () => false,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentPix)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Empty state: sem conta cadastrada não dá pra gerar PIX válido.
          if (noAccounts)
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: AppRadii.small,
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: AppColors.warning, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      l10n.noBankAccounts,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.warning,
                          ),
                    ),
                  ),
                ],
              ),
            ),

          // Bank account selector
          if (!noAccounts)
            bankAccounts.when(
              data: (accounts) => DropdownButtonFormField<String>(
                value: _selectedContaBancariaId,
                decoration: InputDecoration(
                  labelText: l10n.bankAccount,
                ),
                items: [
                  for (final account in accounts)
                    DropdownMenuItem(
                      value: account.id,
                      child: Text(
                        '${account.bancoNome} — ${account.conta}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                ],
                onChanged: (value) {
                  final acc = accountsList.where((a) => a.id == value).firstOrNull;
                  setState(() {
                    _selectedContaBancariaId = value;
                    _selectedContaBancariaChavePix = acc?.chavePix;
                  });
                },
              ),
              loading: () => const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: LinearProgressIndicator(),
              ),
              error: (_, __) => const SizedBox.shrink(),
            ),

          // Mostra a chave PIX que será usada — fundamental pra conferir
          // se o backend está montando o BR Code com a chave correta.
          if (_selectedContaBancariaChavePix != null) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.neutral95,
                borderRadius: AppRadii.small,
              ),
              child: Row(
                children: [
                  const Icon(Icons.key, size: 16, color: AppColors.neutral20),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      '${l10n.pixKey}: ${_selectedContaBancariaChavePix}',
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: AppSpacing.md),

          // Amount input
          AppTextField(
            controller: _amountController,
            label: '${l10n.paymentAmount} (R\$)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: AppSpacing.md),

          // Info text
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: AppRadii.small,
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: AppColors.primary, size: 20),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    l10n.pixQrCodeHint,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                        ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Add PIX payment button
          PrimaryButton(
            label: '${l10n.addPayment} • PIX • R\$ ${_amountController.text}',
            onPressed: (noAccounts || _selectedContaBancariaId == null)
                ? null
                : _addPixPayment,
          ),
        ],
      ),
    );
  }
}
