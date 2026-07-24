import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/constants.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/store_entity.dart';
import '../providers/store_providers.dart';

/// Lista de lojas da empresa (rota `/stores`).
class StoreListScreen extends ConsumerWidget {
  const StoreListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final stores = ref.watch(storeListProvider(kDefaultCompanyId));

    return AsyncScreen<List<StoreEntity>>(
      state: stores,
      isEmpty: (list) => list.isEmpty,
      emptyMessage: l10n.noStores,
      onRetry: () => ref.invalidate(storeListProvider(kDefaultCompanyId)),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(storeListProvider(kDefaultCompanyId)),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: list.length,
          separatorBuilder: (_, index) => const AppDivider(),
          itemBuilder: (context, index) {
            final store = list[index];
            return AppListTile(
              title: store.nome,
              subtitle: '${store.codigo} • ${store.status}',
              onTap: () => context.go('/stores/${store.id}'),
            );
          },
        ),
      ),
    );
  }
}
