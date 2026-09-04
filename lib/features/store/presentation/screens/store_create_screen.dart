import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../providers/store_providers.dart';

/// Formulário de criação de loja (rota `/stores/new`).
class StoreCreateScreen extends ConsumerStatefulWidget {
  const StoreCreateScreen({super.key});

  @override
  ConsumerState<StoreCreateScreen> createState() => _StoreCreateScreenState();
}

class _StoreCreateScreenState extends ConsumerState<StoreCreateScreen> {
  final _nomeController = TextEditingController();

  @override
  void dispose() {
    _nomeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final nome = _nomeController.text.trim();
    var empresaId = ref.read(currentCompanyIdProvider);

    if (nome.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    // Sem empresa — tenta carregar empresas disponíveis antes de redirecionar.
    if (empresaId == null || empresaId.isEmpty) {
      try {
        // Tenta carregar e selecionar uma empresa disponível
        await ref.read(authRepositoryProvider).ensureSessionContext();

        // Verifica novamente se agora temos uma empresa selecionada
        empresaId = ref.read(currentCompanyIdProvider);

        if (empresaId == null || empresaId.isEmpty) {
          // Realmente não há empresas — redireciona para criar
          if (mounted) {
            SnackBar.show(
              context,
              message: l10n.noCompanyMessage,
              type: SnackBarType.warning,
            );
            context.go('/company/new');
          }
          return;
        }
      } on Object {
        // Se falhar ao buscar empresas, redireciona para criar
        if (mounted) {
          SnackBar.show(
            context,
            message: l10n.noCompanyMessage,
            type: SnackBarType.warning,
          );
          context.go('/company/new');
        }
        return;
      }
    }

    try {
      await ref.read(storeCreateProvider.notifier).create({
        'nome': nome,
        'empresaId': empresaId,
      });
      if (mounted) {
        // Limpa o campo para permitir criar outra loja
        _nomeController.clear();
        SnackBar.show(
          context,
          message: l10n.storeCreated,
          type: SnackBarType.success,
        );
        // Volta para a lista que será recarregada automaticamente
        context.pop();
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
