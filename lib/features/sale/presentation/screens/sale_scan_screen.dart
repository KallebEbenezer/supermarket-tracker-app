import 'package:flutter/material.dart' hide SnackBar, IconButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../product/domain/entities/product_entity.dart';
import '../providers/sale_providers.dart';

class SaleScanScreen extends ConsumerStatefulWidget {
  const SaleScanScreen({super.key});

  @override
  ConsumerState<SaleScanScreen> createState() => _SaleScanScreenState();
}

class _SaleScanScreenState extends ConsumerState<SaleScanScreen> {
  MobileScannerController? _cameraController;
  bool _isProcessing = false;
  String? _lastScannedBarcode;
  DateTime? _lastScanTime;

  @override
  void initState() {
    super.initState();
    _cameraController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
      torchEnabled: false,
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _onBarcodeDetected(BarcodeCapture capture) async {
    if (_isProcessing) return;

    final barcodes = capture.barcodes;
    if (barcodes.isEmpty) return;

    final barcode = barcodes.first;
    if (barcode.rawValue == null || barcode.rawValue!.isEmpty) return;

    // Debounce: ignore same barcode within 2 seconds
    final now = DateTime.now();
    if (barcode.rawValue == _lastScannedBarcode &&
        _lastScanTime != null &&
        now.difference(_lastScanTime!) < const Duration(seconds: 2)) {
      return;
    }

    setState(() {
      _isProcessing = true;
      _lastScannedBarcode = barcode.rawValue;
      _lastScanTime = now;
    });

    try {
      final empresaId = ref.read(currentCompanyIdProvider) ?? '';
      final productRepo = ref.read(productRepositoryProvider);
      final products = await productRepo.listProducts(empresaId);

      final match = products.firstWhere(
        (p) => p.codigoBarras == barcode.rawValue,
        orElse: () => const ProductEntity(
          id: '',
          empresaId: '',
          codigoBarras: '',
          nome: '',
          precoVenda: 0,
          estoqueAtual: 0,
          status: '',
        ),
      );

      if (!mounted) return;

      if (match.id.isEmpty) {
        SnackBar.show(
          context,
          message: AppLocalizations.of(context)!.barcodeNotFound,
          type: SnackBarType.error,
        );
      } else {
        final added = ref.read(saleQueueProvider.notifier).addItem(match);
        if (!added && mounted) {
          SnackBar.show(
            context,
            message: AppLocalizations.of(context)!.productAlreadyScanned,
            type: SnackBarType.warning,
          );
        }
      }
    } on Object catch (_) {
      if (!mounted) return;
      SnackBar.show(
        context,
        message: AppLocalizations.of(context)!.productNotFound,
        type: SnackBarType.error,
      );
    } finally {
      if (mounted) setState(() => _isProcessing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final queue = ref.watch(saleQueueProvider);
    final queueNotifier = ref.read(saleQueueProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.saleQueue),
        actions: [
          if (queue.isNotEmpty)
            TextButton(
              onPressed: () => context.push('/sales/summary'),
              child: Text(
                l10n.finishSale,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Stack(
              fit: StackFit.expand,
              children: [
                MobileScanner(
                  controller: _cameraController!,
                  onDetect: _onBarcodeDetected,
                  errorBuilder: (context, error) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.red,
                          ),
                          const SizedBox(height: 16),
                          Text(l10n.barcodeScanError),
                        ],
                      ),
                    );
                  },
                ),
                _buildScanOverlay(),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.all(16),
                    child: SafeArea(
                      child: Text(
                        l10n.barcodeScanHint,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
                if (_isProcessing)
                  const Center(child: CircularProgressIndicator()),
                Positioned(
                  top: 8,
                  right: 8,
                  child: ValueListenableBuilder(
                    valueListenable: _cameraController!,
                    builder: (context, state, child) {
                      return IconButton(
                        icon: Icon(
                          state.torchState == TorchState.on
                              ? Icons.flash_on
                              : Icons.flash_off,
                          color: Colors.white,
                        ),
                        onPressed: () => _cameraController?.toggleTorch(),
                        tooltip: l10n.scanBarcode,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.neutral95,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    child: Row(
                      children: [
                        Text(
                          '${l10n.saleQueue} (${queue.length})',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const Spacer(),
                        if (queue.isNotEmpty)
                          Text(
                            'R\$ ${queueNotifier.subtotal.toStringAsFixed(2)}',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                      ],
                    ),
                  ),
                  const AppDivider(),
                  Expanded(
                    child: queue.isEmpty
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.lg),
                              child: Text(
                                l10n.emptyQueue,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(
                              vertical: AppSpacing.xs,
                            ),
                            itemCount: queue.length,
                            separatorBuilder: (_, __) => const AppDivider(),
                            itemBuilder: (context, index) {
                              final item = queue[index];
                              return ListTile(
                                title: Text(item.productName),
                                subtitle: Text(
                                  '${item.quantity}x R\$ ${item.unitPrice.toStringAsFixed(2)}',
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'R\$ ${item.subtotal.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(
                                        AppIcons.delete,
                                        size: 20,
                                      ),
                                      onPressed: () => queueNotifier
                                          .removeItem(index),
                                      tooltip: l10n.removeItem,
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  if (queue.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      child: PrimaryButton(
                        label:
                            '${l10n.finishSale} • R\$ ${queueNotifier.subtotal.toStringAsFixed(2)}',
                        onPressed: () => context.push('/sales/summary'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanOverlay() {
    return CustomPaint(
      painter: _ScanOverlayPainter(),
      child: const SizedBox.expand(),
    );
  }
}

class _ScanOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black54
      ..style = PaintingStyle.fill;

    final scanAreaWidth = size.width * 0.8;
    final scanAreaHeight = scanAreaWidth * 0.5;
    final left = (size.width - scanAreaWidth) / 2;
    final top = (size.height - scanAreaHeight) / 2;

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addRect(Rect.fromLTWH(left, top, scanAreaWidth, scanAreaHeight))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRect(
      Rect.fromLTWH(left, top, scanAreaWidth, scanAreaHeight),
      borderPaint,
    );

    final cornerPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    const cornerLength = 20.0;

    canvas.drawLine(
      Offset(left, top + cornerLength),
      Offset(left, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top),
      Offset(left + cornerLength, top),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + scanAreaWidth - cornerLength, top),
      Offset(left + scanAreaWidth, top),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaWidth, top),
      Offset(left + scanAreaWidth, top + cornerLength),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left, top + scanAreaHeight - cornerLength),
      Offset(left, top + scanAreaHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left, top + scanAreaHeight),
      Offset(left + cornerLength, top + scanAreaHeight),
      cornerPaint,
    );

    canvas.drawLine(
      Offset(left + scanAreaWidth - cornerLength, top + scanAreaHeight),
      Offset(left + scanAreaWidth, top + scanAreaHeight),
      cornerPaint,
    );
    canvas.drawLine(
      Offset(left + scanAreaWidth, top + scanAreaHeight - cornerLength),
      Offset(left + scanAreaWidth, top + scanAreaHeight),
      cornerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
