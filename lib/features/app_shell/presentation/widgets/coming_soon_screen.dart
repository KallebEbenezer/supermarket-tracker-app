import 'package:flutter/material.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';

/// Tela de espaço reservado para as seções ainda não implementadas.
class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 56),
            const SizedBox(height: AppSpacing.md),
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.xs),
            Text(
              l10n.comingSoonMessage,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
