import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../tokens/app_icons.dart';
import '../tokens/app_layout.dart';

/// Um [AppListTile] com ações de swipe (arrastar para o lado).
///
/// Permite revelar ações de editar e deletar arrastando o item para a esquerda
/// ou direita. As ações aparecem com animação suave e feedback visual.
///
/// Exemplo:
/// ```dart
/// SwipeableListTile(
///   title: 'Produto XYZ',
///   subtitle: 'R$ 10,00',
///   onTap: () => print('Tapped'),
///   onEdit: () => print('Edit'),
///   onDelete: () => print('Delete'),
/// )
/// ```
class SwipeableListTile extends StatelessWidget {
  const SwipeableListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    // Se não há ações, retorna um ListTile simples
    if (onEdit == null && onDelete == null) {
      return _buildListTile(context);
    }

    return Slidable(
      key: ValueKey(title),
      // Ações na direita (arrastar para a esquerda)
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        extentRatio: 0.4,
        children: [
          if (onEdit != null)
            SlidableAction(
              onPressed: (_) => onEdit?.call(),
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              icon: AppIcons.edit,
              label: 'Editar',
            ),
          if (onDelete != null)
            SlidableAction(
              onPressed: (_) => onDelete?.call(),
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Theme.of(context).colorScheme.onError,
              icon: AppIcons.delete,
              label: 'Deletar',
            ),
        ],
      ),
      child: _buildListTile(context),
    );
  }

  Widget _buildListTile(BuildContext context) {
    return ListTile(
      enabled: enabled,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      title: Text(title),
      subtitle: subtitle == null ? null : Text(subtitle!),
      leading: leading,
      trailing: trailing,
      onTap: onTap,
    );
  }
}
