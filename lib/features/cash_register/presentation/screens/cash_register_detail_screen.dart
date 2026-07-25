import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/entities/cash_register_entity.dart';

/// Detalhes de um caixa (rota `/cash/:id`).
class CashRegisterDetailScreen extends ConsumerWidget {
  const CashRegisterDetailScreen({super.key, required this.cashRegisterId});

  final String cashRegisterId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      padding: const EdgeInsets.all(AppSpacing.md),
      children: [
        AppCard(
          child: Column(
            children: [
              AppListTile(title: 'ID', subtitle: cashRegisterId),
              const AppDivider(),
              AppListTile(
                title: l10n.cashRegisterActions,
                subtitle: l10n.comingSoonMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
