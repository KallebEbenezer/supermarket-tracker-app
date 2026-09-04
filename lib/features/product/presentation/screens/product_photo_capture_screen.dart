import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import '../../../../app/l10n/app_localizations.dart';

class ProductPhotoCaptureScreen extends StatefulWidget {
  const ProductPhotoCaptureScreen({super.key});

  @override
  State<ProductPhotoCaptureScreen> createState() =>
      _ProductPhotoCaptureScreenState();
}

class _ProductPhotoCaptureScreenState extends State<ProductPhotoCaptureScreen> {
  CameraController? _cameraController;
  XFile? _capturedPhoto;
  bool _isInitializing = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) setState(() => _hasError = true);
        return;
      }

      final backCamera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      if (mounted) setState(() => _isInitializing = false);
    } catch (e) {
      if (mounted) {
        setState(() {
          _hasError = true;
          _isInitializing = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  Future<void> _takePhoto() async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) {
      return;
    }

    try {
      final photo = await _cameraController!.takePicture();
      setState(() => _capturedPhoto = photo);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.genericError)),
        );
      }
    }
  }

  void _retakePhoto() {
    setState(() => _capturedPhoto = null);
  }

  void _usePhoto() {
    if (_capturedPhoto != null) {
      Navigator.of(context).pop(_capturedPhoto!.path);
    }
  }

  void _skipPhoto() {
    Navigator.of(context).pop<String?>(null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.photoCaptureTitle)),
      body: _hasError
          ? _buildErrorView(l10n)
          : _capturedPhoto != null
              ? _buildPreview(l10n)
              : _buildCameraView(l10n),
    );
  }

  Widget _buildErrorView(AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          Text(l10n.genericError, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              setState(() {
                _hasError = false;
                _isInitializing = true;
              });
              _initializeCamera();
            },
            child: Text(l10n.retry),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: _skipPhoto,
            child: Text(l10n.skipPhoto),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraView(AppLocalizations l10n) {
    if (_isInitializing || _cameraController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Expanded(
          child: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(_cameraController!),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  color: Colors.black54,
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.photoCaptureInstruction,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: _skipPhoto,
                  child: Text(
                    l10n.skipPhoto,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                GestureDetector(
                  onTap: _takePhoto,
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 4),
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 64), // Spacer to balance layout
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(AppLocalizations l10n) {
    return Column(
      children: [
        Expanded(
          child: Image.file(
            File(_capturedPhoto!.path),
            fit: BoxFit.cover,
            width: double.infinity,
          ),
        ),
        Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _retakePhoto,
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retakePhoto),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: _usePhoto,
                    icon: const Icon(Icons.check),
                    label: Text(l10n.usePhoto),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
