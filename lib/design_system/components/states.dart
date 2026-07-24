import 'package:flutter/material.dart' as material;

import '../tokens/app_icons.dart';
import '../tokens/app_layout.dart';
import 'feedback.dart';

class ErrorState extends material.StatelessWidget {
  const ErrorState({
    super.key,
    required this.message,
    this.onRetry,
    this.retryLabel = 'Tentar novamente',
  });

  final String message;
  final void Function()? onRetry;
  final String retryLabel;

  @override
  material.Widget build(material.BuildContext context) => _StateLayout(
    icon: AppIcons.error,
    title: 'Algo deu errado',
    message: message,
    action: onRetry == null
        ? null
        : material.OutlinedButton(
            onPressed: onRetry,
            child: material.Text(retryLabel),
          ),
  );
}

class EmptyState extends material.StatelessWidget {
  const EmptyState({
    super.key,
    required this.message,
    this.title = 'Nada por aqui',
    this.action,
  });

  final String title;
  final String message;
  final material.Widget? action;

  @override
  material.Widget build(material.BuildContext context) => _StateLayout(
    icon: AppIcons.empty,
    title: title,
    message: message,
    action: action,
  );
}

class LoadingState extends material.StatelessWidget {
  const LoadingState({super.key, this.label});

  final String? label;

  @override
  material.Widget build(material.BuildContext context) => Loading(label: label);
}

class _StateLayout extends material.StatelessWidget {
  const _StateLayout({
    required this.icon,
    required this.title,
    required this.message,
    this.action,
  });

  final material.IconData icon;
  final String title;
  final String message;
  final material.Widget? action;

  @override
  material.Widget build(material.BuildContext context) => material.Center(
    child: material.Padding(
      padding: const material.EdgeInsets.all(AppSpacing.xl),
      child: material.Column(
        mainAxisSize: material.MainAxisSize.min,
        children: [
          material.Icon(icon, size: 48),
          const material.SizedBox(height: AppSpacing.md),
          material.Text(
            title,
            style: material.Theme.of(context).textTheme.titleLarge,
          ),
          const material.SizedBox(height: AppSpacing.xs),
          material.Text(message, textAlign: material.TextAlign.center),
          if (action != null) ...[
            const material.SizedBox(height: AppSpacing.md),
            action!,
          ],
        ],
      ),
    ),
  );
}
