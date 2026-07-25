import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../providers/product_providers.dart';

class ProductCreateScreen extends ConsumerStatefulWidget {
  const ProductCreateScreen({super.key});

  @override
  ConsumerState<ProductCreateScreen> createState() =>
      _ProductCreateScreenState();
}

class _ProductCreateScreenState extends ConsumerState<ProductCreateScreen> {
  final _codigoBarrasController = TextEditingController();
  final _nomeController = TextEditingController();
  final _precoVendaController = TextEditingController();
  final _precoCompraController = TextEditingController();
  final _estoqueMinimoController = TextEditingController();

  @override
  void dispose() {
    _codigoBarrasController.dispose();
    _nomeController.dispose();
    _precoVendaController.dispose();
    _precoCompraController.dispose();
    _estoqueMinimoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final codigoBarras = _codigoBarrasController.text.trim();
    final nome = _nomeController.text.trim();
    final precoVenda = _precoVendaController.text.trim();
    final precoCompra = _precoCompraController.text.trim();
    final estoqueMinimo = _estoqueMinimoController.text.trim();

    if (codigoBarras.isEmpty || nome.isEmpty || precoVenda.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    try {
      final created =
          await ref.read(productCreateProvider.notifier).create({
        'empresaId': ref.read(currentCompanyIdProvider) ?? '',
        'codigoBarras': codigoBarras,
        'nome': nome,
        'precoVenda': double.tryParse(precoVenda) ?? 0,
        'precoCompra': double.tryParse(precoCompra) ?? 0,
        'estoqueMinimo': double.tryParse(estoqueMinimo) ?? 0,
      });
      if (mounted) {
        SnackBar.show(
          context,
          message: l10n.productCreated,
          type: SnackBarType.success,
        );
        context.go('/products/${created.id}');
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
    final createState = ref.watch(productCreateProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppTextField(
          controller: _codigoBarrasController,
          label: l10n.productBarcode,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _nomeController,
          label: l10n.productName,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _precoVendaController,
          label: l10n.productSalePrice,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _precoCompraController,
          label: l10n.productPurchasePrice,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: AppSpacing.md),
        AppTextField(
          controller: _estoqueMinimoController,
          label: l10n.productMinStock,
          keyboardType: TextInputType.number,
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
