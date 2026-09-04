import 'dart:async';

import 'package:flutter/material.dart' hide SnackBar;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/store_entity.dart';
import '../providers/store_providers.dart';

/// Lista de lojas da empresa (rota `/stores`).
class StoreListScreen extends ConsumerStatefulWidget {
  const StoreListScreen({super.key});

  @override
  ConsumerState<StoreListScreen> createState() => _StoreListScreenState();
}

class _StoreListScreenState extends ConsumerState<StoreListScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider);

    // Sem empresa selecionada — as lojas pertencem a uma empresa, então
    // orienta o usuário a criar uma antes (em vez de travar no carregamento).
    if (empresaId == null || empresaId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.storesTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(AppIcons.business, size: 64),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.noCompany,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  l10n.noCompanyMessage,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                PrimaryButton(
                  label: l10n.createCompany,
                  onPressed: () => context.go('/company/new'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final stores = ref.watch(storeListProvider(empresaId));

    // Auto-select when the list resolves to a single store. Runs in a
    // post-frame callback so we never mutate state during build, and the
    // notifier fires the router redirect on the next frame.
    ref.listen<AsyncValue<List<StoreEntity>>>(
      storeListProvider(empresaId),
      (prev, next) {
        final value = next.asData?.value;
        if (value == null || value.length != 1) return;
        final currentLojaId = ref.read(sessionManagerProvider).lojaId;
        if (currentLojaId == value.first.id) return;
        unawaited(
          ref.read(sessionManagerProvider).setLojaId(value.first.id),
        );
      },
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.storesTitle)),
      body: AsyncScreen<List<StoreEntity>>(
        state: stores,
        isEmpty: (list) => list.isEmpty,
        emptyTitle: l10n.noStores,
        emptyMessage: l10n.createStoreMessage,
        onRetry: () => ref.invalidate(storeListProvider(empresaId)),
        dataBuilder: (context, list) {
          // While the router is redirecting after auto-selection, keep a
          // minimal placeholder so we don't render the full list behind it.
          final autoSelecting = list.length == 1 &&
              ref.read(sessionManagerProvider).lojaId != list.first.id;
          if (autoSelecting) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.selectingStore),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async =>
                ref.invalidate(storeListProvider(empresaId)),
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
              itemCount: list.length,
              separatorBuilder: (_, index) => const AppDivider(),
              itemBuilder: (context, index) {
                final store = list[index];
                return AppListTile(
                  title: store.nome,
                  subtitle: '${store.codigo} • ${store.status}',
                  onTap: () async {
                    await ref.read(sessionManagerProvider).setLojaId(store.id);
                  },
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/stores/new'),
        child: const Icon(AppIcons.add),
      ),
    );
  }
}
