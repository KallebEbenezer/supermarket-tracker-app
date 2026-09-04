import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../cash_register/domain/entities/bank_account_entity.dart';
import '../../../cash_register/presentation/providers/bank_account_provider.dart';
import '../../domain/entities/payment_item.dart';
import '../providers/payment_provider.dart';

class PaymentCashScreen extends ConsumerStatefulWidget {
  const PaymentCashScreen({super.key});

  @override
  ConsumerState<PaymentCashScreen> createState() => _PaymentCashScreenState();
}

class _PaymentCashScreenState extends ConsumerState<PaymentCashScreen> {
  final _amountController = TextEditingController();
  String? _selectedContaBancariaId;

  @override
  void initState() {
    super.initState();
    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    _amountController.addListener(_onAmountChanged);
    _amountController.text = remaining.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    super.dispose();
  }

  void _onAmountChanged() => setState(() {});

  double get _received {
    return double.tryParse(_amountController.text) ?? 0;
  }

  double get _change {
    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    return _received - remaining;
  }

  void _confirmPayment() {
    if (_received <= 0) return;

    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    final effectiveAmount = _received > remaining ? remaining : _received;

    ref.read(paymentCartProvider.notifier).addPayment(
          PaymentItem(
            tipo: 'DINHEIRO',
            valor: effectiveAmount,
            contaBancariaId: _selectedContaBancariaId,
          ),
        );

    context
      ..pop()
      ..pop();
  }

  void _insertPreset(double value) {
    final current = _received;
    _amountController.text = (current + value).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    final empresaId = ref.read(sessionManagerProvider).empresaId ?? '';
    final bankAccounts = ref.watch(bankAccountListProvider(empresaId));

    // Auto-select principal account
    if (_selectedContaBancariaId == null) {
      bankAccounts.whenData((accounts) {
        final principal = accounts.where((a) => a.principal).firstOrNull;
        if (principal != null && mounted) {
          setState(() => _selectedContaBancariaId = principal.id);
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(l10n.paymentCash)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Bank account selector (optional for cash)
          bankAccounts.when(
            data: (accounts) => accounts.isEmpty
                ? const SizedBox.shrink()
                : DropdownButtonFormField<String>(
                    value: _selectedContaBancariaId,
                    decoration: InputDecoration(
                      labelText: '${l10n.bankAccount} (opcional)',
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
                    onChanged: (value) =>
                        setState(() => _selectedContaBancariaId = value),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Amount received input
          Text(l10n.amountReceived, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          AppTextField(
            controller: _amountController,
            label: '${l10n.amountReceived} (R\$)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            prefixIcon: const Icon(Icons.payments_outlined),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Quick insert buttons
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _PresetChip(label: 'R\$ 5', onTap: () => _insertPreset(5)),
              _PresetChip(label: 'R\$ 10', onTap: () => _insertPreset(10)),
              _PresetChip(label: 'R\$ 20', onTap: () => _insertPreset(20)),
              _PresetChip(label: 'R\$ 50', onTap: () => _insertPreset(50)),
              _PresetChip(label: 'R\$ 100', onTap: () => _insertPreset(100)),
              _PresetChip(
                label: 'Valor exato',
                onTap: () => _amountController.text = remaining.toStringAsFixed(2),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),

          // Summary card
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.remaining),
                      Text('R\$ ${remaining.toStringAsFixed(2)}'),
                    ],
                  ),
                  const AppDivider(indent: 0, endIndent: 0),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.amountReceived),
                      Text('R\$ ${_received.toStringAsFixed(2)}'),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.changeAmount,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        'R\$ ${_change.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: _change >= 0 ? AppColors.success : AppColors.error,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Confirm button
          PrimaryButton(
            label: '${l10n.confirm} • R\$ ${_received.toStringAsFixed(2)}',
            onPressed: _received > 0 ? _confirmPayment : null,
          ),
        ],
      ),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      label: Text(label),
      onPressed: onTap,
    );
  }
}
