import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/cash_register_entity.dart';
import '../providers/cash_register_providers.dart';

/// Lista de caixas da loja (rota `/cash`).
class CashRegisterListScreen extends ConsumerWidget {
  const CashRegisterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cashRegisters = ref.watch(cashRegisterListProvider(''));

    return AsyncScreen<List<CashRegisterEntity>>(
      state: cashRegisters,
      isEmpty: (list) => list.isEmpty,
      emptyMessage: l10n.noCashRegisters,
      onRetry: () => ref.invalidate(cashRegisterListProvider('')),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(cashRegisterListProvider('')),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: list.length,
          separatorBuilder: (_, index) => const AppDivider(),
          itemBuilder: (context, index) {
            final register = list[index];
            return AppListTile(
              title: register.nome,
              subtitle: '${register.codigo} • ${register.status}',
              onTap: () => context.go('/cash/${register.id}'),
            );
          },
        ),
      ),
    );
  }
}
