import 'dart:io';

import 'package:flutter/material.dart' hide SnackBar, IconButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/errors/app_exception.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../providers/product_providers.dart';

class ProductCreateScreen extends ConsumerStatefulWidget {
  const ProductCreateScreen({super.key, this.productId, this.editing = false});

  final String? productId;
  final bool editing;

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

  String? _photoPath;
  bool _loaded = false;

  @override
  void initState() {
    super.initState();
    if (widget.editing && widget.productId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _loadExistingData());
    }
  }

  Future<void> _loadExistingData() async {
    try {
      final product = await ref
          .read(productDetailProvider(widget.productId!).future);
      if (!mounted) return;

      setState(() {
        _codigoBarrasController.text = product.codigoBarras;
        _nomeController.text = product.nome;
        _precoVendaController.text = product.precoVenda.toString();
        _estoqueMinimoController.text = '0';
        _loaded = true;
      });
    } on Object catch (_) {
      if (mounted) {
        setState(() => _loaded = true);
      }
    }
  }

  @override
  void dispose() {
    _codigoBarrasController.dispose();
    _nomeController.dispose();
    _precoVendaController.dispose();
    _precoCompraController.dispose();
    _estoqueMinimoController.dispose();
    super.dispose();
  }

  Future<void> _scanBarcode() async {
    final result = await context.push<String>('/products/new/scan-barcode');
    if (result != null && result.isNotEmpty) {
      setState(() {
        _codigoBarrasController.text = result;
      });
    }
  }

  Future<void> _takePhoto() async {
    final result = await context.push<String>('/products/new/photo');
    if (result != null && result.isNotEmpty) {
      setState(() {
        _photoPath = result;
      });
    }
  }

  String? _encodePhotoAsBase64() {
    if (_photoPath == null) return null;
    try {
      final file = File(_photoPath!);
      final bytes = file.readAsBytesSync();
      return 'data:image/jpeg;base64,${bytesToString(bytes)}';
    } catch (e) {
      return null;
    }
  }

  String bytesToString(List<int> bytes) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    final result = StringBuffer();
    for (var i = 0; i < bytes.length; i += 3) {
      final b1 = bytes[i];
      final b2 = i + 1 < bytes.length ? bytes[i + 1] : 0;
      final b3 = i + 2 < bytes.length ? bytes[i + 2] : 0;
      result.write(chars[b1 >> 2]);
      result.write(chars[((b1 & 3) << 4) | (b2 >> 4)]);
      result.write(i + 1 < bytes.length ? chars[((b2 & 15) << 2) | (b3 >> 6)] : '=');
      result.write(i + 2 < bytes.length ? chars[b3 & 63] : '=');
    }
    return result.toString();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;
    final codigoBarras = _codigoBarrasController.text.trim();
    final nome = _nomeController.text.trim();
    final precoVenda = _precoVendaController.text.trim();
    final precoCompra = _precoCompraController.text.trim();
    final estoqueMinimo = _estoqueMinimoController.text.trim();
    final empresaId = ref.read(currentCompanyIdProvider);

    if (nome.isEmpty || precoVenda.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    final precoVendaValue = double.tryParse(precoVenda);
    if (precoVendaValue == null || precoVendaValue <= 0) {
      SnackBar.show(
        context,
        message: l10n.requiredField,
        type: SnackBarType.warning,
      );
      return;
    }

    if (empresaId == null || empresaId.isEmpty) {
      SnackBar.show(
        context,
        message: l10n.noCompanyMessage,
        type: SnackBarType.warning,
      );
      return;
    }

    try {
      final imagemUrl = _encodePhotoAsBase64();
      final payload = <String, dynamic>{
        'empresaId': empresaId,
        'codigoBarras': codigoBarras.isEmpty ? null : codigoBarras,
        'nome': nome,
        'precoVenda': precoVendaValue,
        'precoCompra': double.tryParse(precoCompra) ?? 0,
        'estoqueMinimo': double.tryParse(estoqueMinimo) ?? 0,
      };
      if (imagemUrl != null) {
        payload['imagemUrl'] = imagemUrl;
      }

      if (widget.editing && widget.productId != null) {
        final updated = await ref
            .read(productCreateProvider.notifier)
            .update(widget.productId!, payload);
        if (mounted) {
          SnackBar.show(
            context,
            message: l10n.productUpdated,
            type: SnackBarType.success,
          );
          context.go('/products/${updated.id}');
        }
      } else {
        final created =
            await ref.read(productCreateProvider.notifier).create(payload);
        if (mounted) {
          SnackBar.show(
            context,
            message: l10n.productCreated,
            type: SnackBarType.success,
          );
          context.go('/products/${created.id}');
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
    final createState = ref.watch(productCreateProvider);

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppTextField(
          controller: _codigoBarrasController,
          label: l10n.productBarcode,
          hint: l10n.productBarcodeHint,
          suffixIcon: IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
            tooltip: l10n.scanBarcode,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SizedBox(
          width: double.infinity,
          child: SecondaryButton(
            label: l10n.scanBarcode,
            leadingIcon: const Icon(Icons.qr_code_scanner),
            onPressed: _scanBarcode,
          ),
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
        const SizedBox(height: AppSpacing.md),

        _buildPhotoSection(l10n),
        const SizedBox(height: AppSpacing.lg),
        PrimaryButton(
          label: l10n.save,
          onPressed: createState.submitting ? null : _submit,
        ),
      ],
    );
  }

  Widget _buildPhotoSection(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.productPhoto,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: AppSpacing.xs),
        if (_photoPath != null) ...[
          Stack(
            children: [
              ClipRRect(
                borderRadius: AppRadii.medium,
                child: Image.file(
                  File(_photoPath!),
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.black54,
                  child: IconButton(
                    icon: const Icon(Icons.close, color: Colors.white, size: 20),
                    onPressed: () => setState(() => _photoPath = null),
                    tooltip: l10n.cancel,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            l10n.photoAttached,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
          ),
        ] else ...[
          Container(
            width: double.infinity,
            height: 160,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).colorScheme.outline,
                style: BorderStyle.solid,
              ),
              borderRadius: AppRadii.medium,
              color: Theme.of(context).colorScheme.surfaceContainerHighest,
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _takePhoto,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_a_photo_outlined,
                    size: 48,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    l10n.noPhotoAttached,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    l10n.addPhoto,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
