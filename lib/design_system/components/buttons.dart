import 'package:flutter/material.dart' as material;

import '../tokens/app_layout.dart';

class PrimaryButton extends material.StatelessWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.expand = true,
  });

  final String label;
  final void Function()? onPressed;
  final material.Widget? leadingIcon;
  final bool expand;

  @override
  material.Widget build(material.BuildContext context) {
    final button = material.FilledButton.icon(
      onPressed: onPressed,
      icon: leadingIcon ?? const material.SizedBox.shrink(),
      label: material.Text(label),
    );
    return expand
        ? material.SizedBox(width: double.infinity, child: button)
        : button;
  }
}

class SecondaryButton extends material.StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.expand = true,
  });

  final String label;
  final void Function()? onPressed;
  final material.Widget? leadingIcon;
  final bool expand;

  @override
  material.Widget build(material.BuildContext context) {
    final button = material.FilledButton.tonalIcon(
      onPressed: onPressed,
      icon: leadingIcon ?? const material.SizedBox.shrink(),
      label: material.Text(label),
    );
    return expand
        ? material.SizedBox(width: double.infinity, child: button)
        : button;
  }
}

class OutlinedButton extends material.StatelessWidget {
  const OutlinedButton({
    super.key,
    required this.label,
    this.onPressed,
    this.leadingIcon,
    this.expand = true,
  });

  final String label;
  final void Function()? onPressed;
  final material.Widget? leadingIcon;
  final bool expand;

  @override
  material.Widget build(material.BuildContext context) {
    final button = material.OutlinedButton.icon(
      onPressed: onPressed,
      icon: leadingIcon ?? const material.SizedBox.shrink(),
      label: material.Text(label),
    );
    return expand
        ? material.SizedBox(width: double.infinity, child: button)
        : button;
  }
}

class IconButton extends material.StatelessWidget {
  const IconButton({
    super.key,
    required this.icon,
    required this.tooltip,
    this.onPressed,
    this.isSelected = false,
  });

  final material.Widget icon;
  final String tooltip;
  final void Function()? onPressed;
  final bool isSelected;

  @override
  material.Widget build(material.BuildContext context) => material.IconButton(
    icon: icon,
    tooltip: tooltip,
    onPressed: onPressed,
    isSelected: isSelected,
    style: material.IconButton.styleFrom(
      padding: const material.EdgeInsets.all(AppSpacing.xs),
    ),
  );
}
