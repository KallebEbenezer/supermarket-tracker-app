import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../providers/customer_providers.dart';

class CustomerCreateScreen extends ConsumerStatefulWidget {
  const CustomerCreateScreen({super.key});

  @override
  ConsumerState<CustomerCreateScreen> createState() =>
      _CustomerCreateScreenState();
}

class _CustomerCreateScreenState extends ConsumerState<CustomerCreateScreen> {
  final _nomeController = TextEditingController();
  final _cpfCnpjController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    _cpfCnpjController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final nome = _nomeController.text.trim();
    final empresaId = ref.read(currentCompanyIdProvider);

    if (nome.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    // Sem empresa — não é possível criar cliente.
    if (empresaId == null || empresaId.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.noCompanyMessage,
        type: SnackBarType.warning,
      );
      context.go('/company/new');
      return;
    }

    try {
      final created =
          await ref.read(customerCreateProvider.notifier).create({
        'empresaId': empresaId,
        'nome': nome,
        'cpfCnpj': _cpfCnpjController.text.trim(),
        'email': _emailController.text.trim(),
        'telefone': _telefoneController.text.trim(),
        'dataNascimento': _dataNascimentoController.text.trim(),
      });
      if (mounted) {
        SnackBar.show(
          context,
          message: l10n.customerCreated,
          type: SnackBarType.success,
        );
        context.go('/customers');
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
    final createState = ref.watch(customerCreateProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppTextField(
          controller: _nomeController,
          label: l10n.customerName,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _cpfCnpjController,
          label: l10n.customerCpfCnpj,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _emailController,
          label: l10n.customerEmail,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _telefoneController,
          label: l10n.customerPhone,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _dataNascimentoController,
          label: l10n.customerBirthDate,
        ),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: l10n.save,
          onPressed: createState.submitting ? null : _submit,
        ),
      ],
    );
  }
}
