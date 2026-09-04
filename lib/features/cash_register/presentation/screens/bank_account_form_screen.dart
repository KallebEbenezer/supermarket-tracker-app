import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../providers/bank_account_provider.dart';

/// Lista dos 10 principais bancos brasileiros.
const _banks = <MapEntry<String, String>>[
  MapEntry('001', 'Banco do Brasil'),
  MapEntry('033', 'Santander'),
  MapEntry('041', 'Banrisul'),
  MapEntry('070', 'BRB'),
  MapEntry('077', 'Banco Inter'),
  MapEntry('104', 'Caixa Econômica Federal'),
  MapEntry('208', 'BTG Pactual'),
  MapEntry('212', 'Banco Original'),
  MapEntry('260', 'Nubank'),
  MapEntry('341', 'Itaú Unibanco'),
  MapEntry('394', 'BMC'),
  MapEntry('613', 'Omni'),
  MapEntry('623', 'Pan'),
  MapEntry('633', 'Rendimento'),
  MapEntry('655', 'Votorantim'),
  MapEntry('707', 'Daycoval'),
  MapEntry('741', 'Ribeirão Preto'),
  MapEntry('745', 'Citibank'),
  MapEntry('748', 'Sicredi'),
  MapEntry('756', 'Sicoob'),
];

/// Formulário de criação/edição de conta bancária.
class BankAccountFormScreen extends ConsumerStatefulWidget {
  const BankAccountFormScreen({super.key, this.accountId, this.editing = false});

  final String? accountId;
  final bool editing;

  @override
  ConsumerState<BankAccountFormScreen> createState() =>
      _BankAccountFormScreenState();
}

class _BankAccountFormScreenState
    extends ConsumerState<BankAccountFormScreen> {
  final _bancoCodigoController = TextEditingController();
  final _bancoNomeController = TextEditingController();
  final _agenciaController = TextEditingController();
  final _contaController = TextEditingController();
  final _titularNomeController = TextEditingController();
  final _titularDocumentoController = TextEditingController();
  final _chavePixController = TextEditingController();

  String _tipo = 'CORRENTE';
  bool _principal = false;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.editing && widget.accountId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingData());
    }
  }

  Future<void> _loadExistingData() async {
    final empresaId = ref.read(currentCompanyIdProvider) ?? '';
    if (empresaId.isEmpty) return;

    final accounts = await ref.read(bankAccountListProvider(empresaId).future);
    final account = accounts.where((a) => a.id == widget.accountId).firstOrNull;
    if (account == null || !mounted) return;

    setState(() {
      _bancoCodigoController.text = account.bancoCodigo;
      _bancoNomeController.text = account.bancoNome;
      _agenciaController.text = account.agencia;
      _contaController.text = account.conta;
      _titularNomeController.text = account.titularNome;
      _titularDocumentoController.text = account.titularDocumento;
      _chavePixController.text = account.chavePix;
      _tipo = account.tipo;
      _principal = account.principal;
      _loaded = true;
    });
  }

  @override
  void dispose() {
    _bancoCodigoController.dispose();
    _bancoNomeController.dispose();
    _agenciaController.dispose();
    _contaController.dispose();
    _titularNomeController.dispose();
    _titularDocumentoController.dispose();
    _chavePixController.dispose();
    super.dispose();
  }

  /// Valida a chave PIX nos formatos aceitos pelo BACEN (CPF, CNPJ, e-mail,
  /// telefone com +55 ou UUID/chave aleatória). Retorna a chave normalizada,
  /// ou null se inválida. Chave vazia é permitida (conta sem PIX).
  String? _validarChavePix(String chave) {
    final trimmed = chave.trim();
    if (trimmed.isEmpty) return null;

    if (trimmed.contains('@')) {
      final email = RegExp(r'^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$');
      return email.hasMatch(trimmed) ? trimmed.toLowerCase() : null;
    }
    final uuid = RegExp(
        r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    if (uuid.hasMatch(trimmed)) return trimmed.toLowerCase();

    if (trimmed.startsWith('+') || trimmed.startsWith('55')) {
      final digits = trimmed.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 12 || digits.length > 13) return null;
      final numero = digits.length == 13 ? digits.substring(2) : digits.substring(2);
      return '+55$numero';
    }

    final digits = trimmed.replaceAll(RegExp(r'\D'), '');
    if (digits.length == 11 && _isCpfValido(digits)) return digits;
    if (digits.length == 14 && _isCnpjValido(digits)) return digits;
    return null;
  }

  bool _isCpfValido(String cpf) {
    if (RegExp(r'^(\d)\1{10}$').hasMatch(cpf)) return false;
    int dv(int posicao) {
      var sum = 0;
      var peso = posicao + 1; // 1º dígito: pesos 10..2; 2º dígito: pesos 11..2
      for (var i = 0; i < posicao; i++) {
        sum += int.parse(cpf[i]) * peso--;
      }
      final r = sum % 11;
      return r < 2 ? 0 : 11 - r;
    }

    return dv(9) == int.parse(cpf[9]) && dv(10) == int.parse(cpf[10]);
  }

  bool _isCnpjValido(String cnpj) {
    if (RegExp(r'^(\d)\1{13}$').hasMatch(cnpj)) return false;
    final pesos1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    final pesos2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2];
    int dv(List<int> pesos) {
      var sum = 0;
      for (var i = 0; i < pesos.length; i++) {
        sum += int.parse(cnpj[i]) * pesos[i];
      }
      final r = sum % 11;
      return r < 2 ? 0 : 11 - r;
    }

    return dv(pesos1) == int.parse(cnpj[12]) && dv(pesos2) == int.parse(cnpj[13]);
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final bancoCodigo = _bancoCodigoController.text.trim();
    final bancoNome = _bancoNomeController.text.trim();
    final agencia = _agenciaController.text.trim();
    final conta = _contaController.text.trim();
    final titularNome = _titularNomeController.text.trim();

    if (bancoNome.isEmpty || agencia.isEmpty || conta.isEmpty || titularNome.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    final chavePix = _validarChavePix(_chavePixController.text);
    if (chavePix == null) {
      SnackBar.show(
        context,
        message: 'Chave PIX inválida',
        type: SnackBarType.warning,
      );
      return;
    }

    final empresaId = ref.read(currentCompanyIdProvider) ?? '';
    if (empresaId.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.noCompany,
        type: SnackBarType.warning,
      );
      return;
    }

    final payload = <String, dynamic>{
      'empresaId': empresaId,
      'bancoCodigo': bancoCodigo,
      'bancoNome': bancoNome,
      'agencia': agencia,
      'conta': conta,
      'tipo': _tipo,
      'titularNome': titularNome,
      'titularDocumento': _titularDocumentoController.text.trim(),
      'chavePix': chavePix,
      'principal': _principal,
    };

    try {
      if (widget.editing && widget.accountId != null) {
        await ref
            .read(bankAccountFormProvider.notifier)
            .update(widget.accountId!, payload);
        if (mounted) {
          SnackBar.show(
            context,
            message: l10n.bankAccountUpdated,
            type: SnackBarType.success,
          );
          Navigator.of(context).pop();
        }
      } else {
        await ref
            .read(bankAccountFormProvider.notifier)
            .create(payload);
        if (mounted) {
          SnackBar.show(
            context,
            message: l10n.bankAccountCreated,
            type: SnackBarType.success,
          );
          Navigator.of(context).pop();
        }
      }
    } on Object catch (error) {
      if (mounted) {
        final message =
            error is AppException ? error.message : l10n.genericError;
        SnackBar.show(context, message: message, type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final formState = ref.watch(bankAccountFormProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.editing ? l10n.editBankAccount : l10n.linkBankAccount,
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          DropdownButtonFormField<MapEntry<String, String>>(
            value: _banks.firstWhere(
              (b) => b.key == _bancoCodigoController.text,
              orElse: () => _banks.first,
            ),
            decoration: InputDecoration(labelText: l10n.bankName),
            items: _banks
                .map(
                  (b) => DropdownMenuItem(
                    value: b,
                    child: Text('${b.key} - ${b.value}'),
                  ),
                )
                .toList(),
            onChanged: (entry) {
              if (entry != null) {
                setState(() {
                  _bancoCodigoController.text = entry.key;
                  _bancoNomeController.text = entry.value;
                });
              }
            },
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _agenciaController,
            label: l10n.bankAgency,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _contaController,
            label: l10n.bankAccountNumber,
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            value: _tipo,
            decoration: InputDecoration(labelText: l10n.bankAccountType),
            items: [
              DropdownMenuItem(value: 'CORRENTE', child: Text(l10n.bankCurrent)),
              DropdownMenuItem(value: 'POUPANCA', child: Text(l10n.bankSavings)),
              DropdownMenuItem(
                value: 'PAGAMENTO',
                child: Text(l10n.bankPayment),
              ),
            ],
            onChanged: (value) => setState(() => _tipo = value ?? 'CORRENTE'),
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _titularNomeController,
            label: l10n.bankAccountHolder,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _titularDocumentoController,
            label: l10n.bankAccountDocument,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _chavePixController,
            label: l10n.pixKey,
          ),
          const SizedBox(height: AppSpacing.md),
          CheckboxListTile(
            value: _principal,
            onChanged: (value) => setState(() => _principal = value ?? false),
            title: Text(l10n.principalAccount),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: AppSpacing.lg),
          PrimaryButton(
            label: widget.editing ? l10n.save : l10n.linkBankAccount,
            onPressed: formState.submitting ? null : _submit,
          ),
        ],
      ),
    );
  }
}
