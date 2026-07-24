import 'package:flutter/material.dart' as material;

import '../tokens/app_effects.dart';
import '../tokens/app_layout.dart';

abstract final class SnackBar {
  static void show(
    material.BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    String? actionLabel,
    void Function()? onAction,
  }) {
    final color = switch (type) {
      SnackBarType.success => material.Colors.green.shade800,
      SnackBarType.warning => material.Colors.orange.shade800,
      SnackBarType.error => material.Theme.of(context).colorScheme.error,
      SnackBarType.info => material.Theme.of(
        context,
      ).colorScheme.inverseSurface,
    };
    material.ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        material.SnackBar(
          behavior: material.SnackBarBehavior.floating,
          backgroundColor: color,
          content: material.Text(message),
          action: actionLabel == null
              ? null
              : material.SnackBarAction(
                  label: actionLabel,
                  onPressed: onAction ?? () {},
                ),
        ),
      );
  }
}

enum SnackBarType { success, warning, error, info }

abstract final class Dialogs {
  static Future<bool?> confirm(
    material.BuildContext context, {
    required String title,
    required String message,
    String cancelLabel = 'Cancelar',
    String confirmLabel = 'Confirmar',
  }) => material.showDialog<bool>(
    context: context,
    builder: (context) => material.AlertDialog(
      title: material.Text(title),
      content: material.Text(message),
      actions: [
        material.TextButton(
          onPressed: () => material.Navigator.pop(context, false),
          child: material.Text(cancelLabel),
        ),
        material.FilledButton(
          onPressed: () => material.Navigator.pop(context, true),
          child: material.Text(confirmLabel),
        ),
      ],
    ),
  );
}

abstract final class BottomSheet {
  static Future<T?> show<T>(
    material.BuildContext context, {
    required material.Widget child,
    bool isScrollControlled = true,
  }) => material.showModalBottomSheet<T>(
    context: context,
    isScrollControlled: isScrollControlled,
    showDragHandle: true,
    builder: (context) => material.SafeArea(
      child: material.Padding(
        padding: const material.EdgeInsets.all(AppSpacing.md),
        child: child,
      ),
    ),
  );
}

class Loading extends material.StatelessWidget {
  const Loading({super.key, this.label});

  final String? label;

  @override
  material.Widget build(material.BuildContext context) => material.Center(
    child: material.Column(
      mainAxisSize: material.MainAxisSize.min,
      children: [
        const material.CircularProgressIndicator(),
        if (label != null) ...[
          const material.SizedBox(height: AppSpacing.sm),
          material.Text(label!),
        ],
      ],
    ),
  );
}

class Skeleton extends material.StatelessWidget {
  const Skeleton({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = AppRadii.small,
  });

  final double width;
  final double height;
  final material.BorderRadius borderRadius;

  @override
  material.Widget build(material.BuildContext context) => material.Container(
    width: width,
    height: height,
    decoration: material.BoxDecoration(
      color: material.Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: borderRadius,
    ),
  );
}

class Shimmer extends material.StatefulWidget {
  const Shimmer({super.key, required this.child});

  final material.Widget child;

  @override
  material.State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends material.State<Shimmer>
    with material.SingleTickerProviderStateMixin {
  late final material.AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = material.AnimationController(
      vsync: this,
      duration: AppMotion.slow,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  material.Widget build(material.BuildContext context) =>
      material.AnimatedBuilder(
        animation: _controller,
        child: widget.child,
        builder: (context, child) => material.ShaderMask(
          blendMode: material.BlendMode.srcATop,
          shaderCallback: (bounds) => material.LinearGradient(
            begin: material.Alignment(-1.0 + (_controller.value * 2), 0),
            end: material.Alignment(1.0 + (_controller.value * 2), 0),
            colors: [
              material.Colors.transparent,
              material.Colors.white.withValues(alpha: 0.35),
              material.Colors.transparent,
            ],
          ).createShader(bounds),
          child: child,
        ),
      );
}
