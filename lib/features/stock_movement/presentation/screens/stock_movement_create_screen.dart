import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../../../product/presentation/providers/product_providers.dart';
import '../providers/stock_movement_providers.dart';

/// Formulário de criação de movimentação de estoque (rota `/stock/new`).
class StockMovementCreateScreen extends ConsumerStatefulWidget {
  const StockMovementCreateScreen({super.key});

  @override
  ConsumerState<StockMovementCreateScreen> createState() =>
      _StockMovementCreateScreenState();
}

class _StockMovementCreateScreenState
    extends ConsumerState<StockMovementCreateScreen> {
  final _quantidadeController = TextEditingController();
  final _motivoController = TextEditingController();
  ProductEntity? _selectedProduct;
  String? _selectedTipo;

  @override
  void dispose() {
    _quantidadeController.dispose();
    _motivoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.read(currentCompanyIdProvider) ?? '';
    final usuarioId =
        ref.read(sessionManagerProvider).currentUser?.id ?? '';

    if (_selectedProduct == null || _selectedTipo == null) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    final quantidadeText = _quantidadeController.text.trim();
    final quantidade = double.tryParse(quantidadeText);
    if (quantidade == null || quantidade <= 0) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    try {
      final created = await ref
          .read(stockMovementCreateProvider.notifier)
          .create({
        'empresaId': empresaId,
        'produtoId': _selectedProduct!.id,
        'usuarioId': usuarioId,
        'tipo': _selectedTipo!,
        'quantidade': quantidade,
        'motivo': _motivoController.text.trim(),
      });
      if (mounted) {
        ref.invalidate(stockMovementListProvider(empresaId));
        SnackBar.show(
          context,
          message: l10n.stockMovementCreated,
          type: SnackBarType.success,
        );
        context.go('/stock');
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
    final empresaId = ref.watch(currentCompanyIdProvider) ?? '';
    final createState = ref.watch(stockMovementCreateProvider);
    final productsAsync = ref.watch(productListProvider(empresaId));

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        // Product selector
        productsAsync.when(
          loading: () => const SizedBox(
            height: 56,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Text(l10n.genericError),
          data: (products) => DropdownButtonFormField<ProductEntity>(
            value: _selectedProduct,
            decoration: InputDecoration(labelText: l10n.stockMovementProduct),
            items: products
                .map(
                  (p) => DropdownMenuItem(
                    value: p,
                    child: Text(p.nome),
                  ),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedProduct = value),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Type selector
        DropdownButtonFormField<String>(
          value: _selectedTipo,
          decoration: InputDecoration(labelText: l10n.stockMovementType),
          items: [
            DropdownMenuItem(value: 'ENTRADA', child: Text(l10n.stockIn)),
            DropdownMenuItem(value: 'SAIDA', child: Text(l10n.stockOut)),
            DropdownMenuItem(value: 'AJUSTE', child: Text(l10n.stockAdjust)),
          ],
          onChanged: (value) => setState(() => _selectedTipo = value),
        ),
        const SizedBox(height: AppSpacing.md),

        // Quantity
        AppTextField(
          controller: _quantidadeController,
          label: l10n.stockMovementQuantity,
          hint: l10n.stockMovementQuantityHint,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
        ),
        const SizedBox(height: AppSpacing.md),

        // Reason (optional)
        AppTextField(
          controller: _motivoController,
          label: l10n.stockMovementReason,
          hint: l10n.stockMovementReasonHint,
        ),
        const SizedBox(height: AppSpacing.lg),

        // Submit
        PrimaryButton(
          label: l10n.registerStock,
          onPressed: createState.submitting ? null : _submit,
        ),
      ],
    );
  }
}
