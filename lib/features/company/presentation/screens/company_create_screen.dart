import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';

class CompanyCreateScreen extends ConsumerStatefulWidget {
  const CompanyCreateScreen({super.key});

  @override
  ConsumerState<CompanyCreateScreen> createState() => _CompanyCreateScreenState();
}

class _CompanyCreateScreenState extends ConsumerState<CompanyCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _razaoSocialController = TextEditingController();
  final _nomeFantasiaController = TextEditingController();
  final _cnpjController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _razaoSocialController.dispose();
    _nomeFantasiaController.dispose();
    _cnpjController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return fieldName;
    return null;
  }

  String? _validateCnpj(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length != 14) return l10n!.validationCnpjInvalid;
    return null;
  }

  AppLocalizations? get l10n => AppLocalizations.of(context);

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final usuarioId = ref.read(sessionManagerProvider).currentUser?.id ?? '';
    if (usuarioId.isEmpty) return;

    setState(() => _submitting = true);
    try {
      final payload = {
        'razaoSocial': _razaoSocialController.text.trim(),
        'nomeFantasia': _nomeFantasiaController.text.trim(),
        'cnpj': _cnpjController.text.replaceAll(RegExp(r'\D'), ''),
        'usuarioId': usuarioId,
      };

      final company = await ref.read(companyRepositoryProvider).createCompany(payload);
      await ref.read(empresaIdNotifierProvider.notifier).select(company.id);

      if (mounted) {
        SnackBar.show(context, message: l10n!.companyCreated, type: SnackBarType.success);
        context.go('/dashboard');
      }
    } on Object catch (error) {
      if (mounted) {
        final message = error is AppException ? error.message : l10n!.genericError;
        SnackBar.show(context, message: message, type: SnackBarType.error);
      }
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.createCompany)),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(AppIcons.business, size: 64, color: AppColors.primary),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    l10n.noCompanyMessage,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  TextFormField(
                    controller: _razaoSocialController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l10n.companyRazaoSocial),
                    validator: (v) => _validateRequired(v, l10n.requiredField),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _nomeFantasiaController,
                    textCapitalization: TextCapitalization.words,
                    decoration: InputDecoration(labelText: l10n.companyNomeFantasia),
                    validator: (v) => _validateRequired(v, l10n.requiredField),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TextFormField(
                    controller: _cnpjController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: l10n.companyCnpj),
                    validator: _validateCnpj,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PrimaryButton(
                    label: l10n.createCompany,
                    onPressed: _submitting ? null : _submit,
                    leadingIcon: _submitting
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(AppIcons.check),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
