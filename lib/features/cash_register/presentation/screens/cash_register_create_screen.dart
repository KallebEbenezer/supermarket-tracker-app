import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../providers/cash_register_providers.dart';

/// Formulário de criação de caixa (rota `/cash/new`).
class CashRegisterCreateScreen extends ConsumerStatefulWidget {
  const CashRegisterCreateScreen({super.key});

  @override
  ConsumerState<CashRegisterCreateScreen> createState() =>
      _CashRegisterCreateScreenState();
}

class _CashRegisterCreateScreenState
    extends ConsumerState<CashRegisterCreateScreen> {
  final _codigoController = TextEditingController();
  final _nomeController = TextEditingController();

  @override
  void dispose() {
    _codigoController.dispose();
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final codigo = _codigoController.text.trim();
    final nome = _nomeController.text.trim();
    final lojaId = ref.read(sessionManagerProvider).lojaId ?? '';

    if (codigo.isEmpty || nome.isEmpty || lojaId.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    try {
      final created = await ref.read(cashRegisterCreateProvider.notifier).create({
        'lojaId': lojaId,
        'codigo': codigo,
        'nome': nome,
      });
      if (mounted) {
        SnackBar.show(
          context,
          message: l10n.cashRegisterCreated,
          type: SnackBarType.success,
        );
        context.go('/cash/${created.id}');
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
    final createState = ref.watch(cashRegisterCreateProvider);

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
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: l10n.save,
          onPressed: createState.submitting ? null : _submit,
        ),
      ],
    );
  }
}
