import 'package:flutter/material.dart' hide SnackBar, OutlinedButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nfc_manager/nfc_manager.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../cash_register/presentation/providers/bank_account_provider.dart';
import '../../domain/entities/payment_item.dart';
import '../providers/payment_provider.dart';

enum _PaymentStatus { idle, readingNfc, processing, success, error }

class PaymentCardScreen extends ConsumerStatefulWidget {
  const PaymentCardScreen({super.key});

  @override
  ConsumerState<PaymentCardScreen> createState() => _PaymentCardScreenState();
}

class _PaymentCardScreenState extends ConsumerState<PaymentCardScreen> {
  late final TextEditingController _amountController;
  bool _isDebit = true;
  int _installments = 1;
  String? _selectedContaBancariaId;
  _PaymentStatus _status = _PaymentStatus.idle;
  String? _errorMessage;
  String? _authorizationCode;

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

  Future<void> _readNfcAndProcess() async {
    final l10n = AppLocalizations.of(context)!;
    final available = await NfcManager.instance.isAvailable();
    if (!available) {
      if (!mounted) return;
      setState(() {
        _status = _PaymentStatus.error;
        _errorMessage = l10n.nfcUnavailable;
      });
      return;
    }

    setState(() {
      _status = _PaymentStatus.readingNfc;
      _errorMessage = null;
    });

    try {
      await NfcManager.instance.startSession(
        pollingOptions: {NfcPollingOption.iso14443, NfcPollingOption.iso15693, NfcPollingOption.iso18092},
        onDiscovered: (NfcTag tag) async {
          final data = tag.data as Map?;
          final nfcaData = data?['nfca'];
          final uid = nfcaData is Map ? nfcaData['identifier'] : null;
          if (uid != null && uid is List) {
            final uidHex = (uid as List<int>)
                .map((b) => b.toRadixString(16).padLeft(2, '0'))
                .join(':')
                .toUpperCase();

            await NfcManager.instance.stopSession();
            if (mounted) {
              await _processPayment(uidHex);
            }
          } else {
            await NfcManager.instance.stopSession();
            if (mounted) {
              setState(() {
                _status = _PaymentStatus.error;
                _errorMessage = l10n.nfcReadError;
              });
            }
          }
        },
      );
    } on Object {
      if (mounted) {
        setState(() {
          _status = _PaymentStatus.error;
          _errorMessage = l10n.nfcReadError;
        });
      }
    }
  }

  Future<void> _processPayment(String cardUid) async {
    final l10n = AppLocalizations.of(context)!;
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      setState(() {
        _status = _PaymentStatus.error;
        _errorMessage = 'Valor inválido';
      });
      return;
    }

    final remaining = ref.read(paymentCartProvider.notifier).remaining;
    final effectiveAmount = amount > remaining ? remaining : amount;

    setState(() => _status = _PaymentStatus.processing);

    try {
      final saleRepo = ref.read(saleRepositoryProvider);
      final result = await saleRepo.processCardPayment(
        vendaId: _getVendaId(),
        contaBancariaId: _selectedContaBancariaId,
        valor: effectiveAmount,
        modalidade: _isDebit ? 'DEBITO' : 'CREDITO',
        parcelas: _installments,
        referenciaNfc: cardUid,
      );

      if (!mounted) return;

      if (result['aprovado'] == true) {
        // Add payment to cart
        ref.read(paymentCartProvider.notifier).addPayment(
              PaymentItem(
                tipo: 'CARTAO',
                valor: effectiveAmount,
                modalidadeCartao: _isDebit ? 'DEBITO' : 'CREDITO',
                parcelas: _installments,
                contaBancariaId: _selectedContaBancariaId,
                referencia: cardUid,
              ),
            );

        setState(() {
          _status = _PaymentStatus.success;
          _authorizationCode = result['codigoAutorizacao'];
        });

        SnackBar.show(context, message: l10n.nfcReadSuccess, type: SnackBarType.success);

        // Navigate back after success
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          context
            ..pop()
            ..pop();
        }
      } else {
        setState(() {
          _status = _PaymentStatus.error;
          _errorMessage = result['mensagem'] ?? 'Pagamento rejeitado';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _status = _PaymentStatus.error;
        _errorMessage = e.toString();
      });
    }
  }

  String _getVendaId() {
    // In the current flow, the sale is not yet created when adding payments.
    // The payment will be included when the sale is finalized.
    // For now, we'll use a placeholder that will be replaced during finalization.
    return '';
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
      appBar: AppBar(title: Text(l10n.paymentCard)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Bank account selector
          bankAccounts.when(
            data: (accounts) => accounts.isEmpty
                ? const SizedBox.shrink()
                : DropdownButtonFormField<String>(
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
                    onChanged: (value) =>
                        setState(() => _selectedContaBancariaId = value),
                  ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
          const SizedBox(height: AppSpacing.md),

          // Amount input
          AppTextField(
            controller: _amountController,
            label: '${l10n.paymentAmount} (R\$)',
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Debit/Credit toggle
          Text(l10n.cardType, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppSpacing.sm),
          SegmentedButton<bool>(
            segments: [
              ButtonSegment(value: true, label: Text(l10n.cardDebit)),
              ButtonSegment(value: false, label: Text(l10n.cardCredit)),
            ],
            selected: {_isDebit},
            onSelectionChanged: (selected) {
              setState(() {
                _isDebit = selected.first;
                if (_isDebit) _installments = 1;
              });
            },
          ),

          // Installments slider (credit only)
          if (!_isDebit) ...[
            const SizedBox(height: AppSpacing.lg),
            Text(
              '${l10n.installments}: ${_installments}x',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: _installments.toDouble(),
              min: 1,
              max: 12,
              divisions: 11,
              label: '${_installments}x',
              onChanged: (v) => setState(() => _installments = v.round()),
            ),
          ],
          const SizedBox(height: AppSpacing.lg),

          // NFC card section
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Column(
                children: [
                  if (_status == _PaymentStatus.success) ...[
                    Icon(Icons.check_circle, size: 64, color: AppColors.success),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      l10n.nfcReadSuccess,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.success,
                          ),
                    ),
                    if (_authorizationCode != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Código: $_authorizationCode',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontFamily: 'monospace',
                            ),
                      ),
                    ],
                  ] else if (_status == _PaymentStatus.error) ...[
                    Icon(Icons.error_outline, size: 64, color: AppColors.error),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _errorMessage ?? 'Erro desconhecido',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    OutlinedButton(
                      label: l10n.nfcReadAgain,
                      leadingIcon: const Icon(Icons.refresh, size: 18),
                      onPressed: () => setState(() {
                        _status = _PaymentStatus.idle;
                        _errorMessage = null;
                      }),
                    ),
                  ] else ...[
                    Icon(
                      Icons.nfc,
                      size: 64,
                      color: _status == _PaymentStatus.readingNfc
                          ? AppColors.primary
                          : _status == _PaymentStatus.processing
                              ? AppColors.warning
                              : AppColors.neutral90,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      _status == _PaymentStatus.readingNfc
                          ? l10n.nfcReading
                          : _status == _PaymentStatus.processing
                              ? l10n.processing
                              : l10n.nfcTapCard,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    PrimaryButton(
                      label: _status == _PaymentStatus.readingNfc
                          ? l10n.nfcReading
                          : _status == _PaymentStatus.processing
                              ? l10n.processing
                              : l10n.nfcRead,
                      onPressed: (_status == _PaymentStatus.readingNfc ||
                              _status == _PaymentStatus.processing)
                          ? null
                          : _readNfcAndProcess,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
