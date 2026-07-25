import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../providers/store_providers.dart';

/// Formulário de criação de loja (rota `/stores/new`).
class StoreCreateScreen extends ConsumerStatefulWidget {
  const StoreCreateScreen({super.key});

  @override
  ConsumerState<StoreCreateScreen> createState() => _StoreCreateScreenState();
}

class _StoreCreateScreenState extends ConsumerState<StoreCreateScreen> {
  final _codigoController = TextEditingController();
  final _nomeController = TextEditingController();
  final _empresaIdController = TextEditingController();
  final _statusController = TextEditingController();

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    _empresaIdController.dispose();
    _statusController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final codigo = _codigoController.text.trim();
    final nome = _nomeController.text.trim();

    if (codigo.isEmpty || nome.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    try {
      final created = await ref.read(storeCreateProvider.notifier).create({
        'codigo': codigo,
        'nome': nome,
        'empresaId': ref.read(currentCompanyIdProvider) ?? '',
        'status': _statusController.text.trim(),
      });
      if (mounted) {
        SnackBar.show(
          context,
          message: l10n.storeCreated,
          type: SnackBarType.success,
        );
        context.go('/stores/${created.id}');
      }
    } on Object catch (error) {
      if (mounted) {
        final message = error is AppException ? error.message : l10n.genericError;
        SnackBar.show(context, message: message, type: SnackBarType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final createState = ref.watch(storeCreateProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppTextField(
          controller: _codigoController,
          label: l10n.storeCode,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _nomeController,
          label: l10n.storeName,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _empresaIdController,
          label: l10n.storeCompany,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _statusController,
          label: l10n.storeStatus,
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
