import 'package:flutter/material.dart' as material;

import '../tokens/app_effects.dart';
import '../tokens/app_layout.dart';

class Avatar extends material.StatelessWidget {
  const Avatar({super.key, this.image, this.initials, this.radius = 20});

  final material.ImageProvider? image;
  final String? initials;
  final double radius;

  @override
  material.Widget build(material.BuildContext context) => material.CircleAvatar(
    radius: radius,
    backgroundImage: image,
    child: image == null && initials != null ? material.Text(initials!) : null,
  );
}

class Badge extends material.StatelessWidget {
  const Badge({super.key, required this.child, this.label});

  final material.Widget child;
  final String? label;

  @override
  material.Widget build(material.BuildContext context) => material.Badge(
    label: label == null ? null : material.Text(label!),
    child: child,
  );
}

class AppCard extends material.StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const material.EdgeInsets.all(AppSpacing.md),
  });

  final material.Widget child;
  final void Function()? onTap;
  final material.EdgeInsetsGeometry padding;

  @override
  material.Widget build(material.BuildContext context) => material.Card(
    elevation: AppElevation.low,
    child: material.InkWell(
      borderRadius: AppRadii.medium,
      onTap: onTap,
      child: material.Padding(padding: padding, child: child),
    ),
  );
}

class AppListTile extends material.StatelessWidget {
  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;
  final material.Widget? leading;
  final material.Widget? trailing;
  final void Function()? onTap;

  @override
  material.Widget build(material.BuildContext context) => material.ListTile(
    contentPadding: const material.EdgeInsets.symmetric(
      horizontal: AppSpacing.md,
      vertical: AppSpacing.xs,
    ),
    title: material.Text(title),
    subtitle: subtitle == null ? null : material.Text(subtitle!),
    leading: leading,
    trailing: trailing,
    onTap: onTap,
  );
}

class AppDivider extends material.StatelessWidget {
  const AppDivider({super.key, this.indent = 0, this.endIndent = 0});

  final double indent;
  final double endIndent;

  @override
  material.Widget build(material.BuildContext context) =>
      material.Divider(indent: indent, endIndent: endIndent, height: 1);
}
