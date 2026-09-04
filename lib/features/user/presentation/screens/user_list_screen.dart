import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_providers.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider);

    // Sem empresa — usuários pertencem a uma empresa.
    if (empresaId == null || empresaId.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navUsers)),
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

    final users = ref.watch(userListProvider(empresaId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navUsers)),
      body: AsyncScreen<List<UserEntity>>(
        state: users,
        isEmpty: (list) => list.isEmpty,
        emptyMessage: l10n.noUsers,
        onRetry: () => ref.invalidate(userListProvider(empresaId)),
        dataBuilder: (context, list) => RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(userListProvider(empresaId)),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: list.length,
            separatorBuilder: (_, index) => const AppDivider(),
            itemBuilder: (context, index) {
              final user = list[index];
              return AppListTile(
                title: user.nome,
                subtitle: user.email,
                onTap: () => context.go('/users/${user.id}'),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/users/new'),
        child: const Icon(AppIcons.add),
      ),
    );
  }
}
