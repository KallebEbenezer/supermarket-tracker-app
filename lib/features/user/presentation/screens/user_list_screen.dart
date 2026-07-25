import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/constants.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_providers.dart';

class UserListScreen extends ConsumerWidget {
  const UserListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final users = ref.watch(userListProvider(kDefaultCompanyId));

    return AsyncScreen<List<UserEntity>>(
      state: users,
      isEmpty: (list) => list.isEmpty,
      emptyMessage: l10n.noUsers,
      onRetry: () => ref.invalidate(userListProvider(kDefaultCompanyId)),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(userListProvider(kDefaultCompanyId)),
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
    );
  }
}
