import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/cash_register_entity.dart';
import '../providers/cash_register_providers.dart';

/// Lista de caixas da loja (rota `/cash`).
class CashRegisterListScreen extends ConsumerWidget {
  const CashRegisterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final lojaId = ref.watch(sessionManagerProvider).lojaId;

    // Sem loja selecionada — um caixa pertence a uma loja, então orienta o
    // usuário a criar/entrar numa loja antes (com ação clara).
    if (lojaId == null || lojaId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navCash)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(AppIcons.store, size: 64),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.noStores,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.createStoreMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: l10n.createStore,
                  onPressed: () => context.go('/stores/new'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final cashRegisters = ref.watch(cashRegisterListProvider(lojaId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCash)),
      body: AsyncScreen<List<CashRegisterEntity>>(
        state: cashRegisters,
        isEmpty: (list) => list.isEmpty,
        emptyTitle: l10n.noCashRegisters,
        emptyMessage: l10n.createCashRegisterMessage,
        onRetry: () => ref.invalidate(cashRegisterListProvider(lojaId)),
        dataBuilder: (context, list) => RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(cashRegisterListProvider(lojaId)),
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/cash/new'),
        child: const Icon(AppIcons.add),
      ),
    );
  }
}
