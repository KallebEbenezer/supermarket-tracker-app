import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/store_entity.dart';
import '../providers/store_providers.dart';

/// Detalhes de uma loja (rota `/stores/:id`).
class StoreDetailScreen extends ConsumerWidget {
  const StoreDetailScreen({super.key, required this.storeId});

  final String storeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final store = ref.watch(storeDetailProvider(storeId));

    return AsyncScreen<StoreEntity>(
      state: store,
      onRetry: () => ref.invalidate(storeDetailProvider(storeId)),
      dataBuilder: (context, data) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                AppListTile(title: l10n.storeName, subtitle: data.nome),
                const AppDivider(),
                AppListTile(title: l10n.storeCode, subtitle: data.codigo),
                const AppDivider(),
                AppListTile(title: l10n.storeCompany, subtitle: data.empresaId),
                const AppDivider(),
                AppListTile(title: l10n.storeStatus, subtitle: data.status),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
