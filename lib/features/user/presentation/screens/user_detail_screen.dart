import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/constants.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/user_entity.dart';
import '../providers/user_providers.dart';

class UserDetailScreen extends ConsumerWidget {
  const UserDetailScreen({super.key, required this.userId});

  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final users = ref.watch(userListProvider(kDefaultCompanyId));

    return AsyncScreen<List<UserEntity>>(
      state: users,
      onRetry: () => ref.invalidate(userListProvider(kDefaultCompanyId)),
      dataBuilder: (context, list) {
        final user = list.where((u) => u.id == userId).firstOrNull;
        if (user == null) {
          return Center(child: Text(l10n.genericError));
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                children: [
                  AppListTile(title: l10n.userName, subtitle: user.nome),
                  const AppDivider(),
                  AppListTile(title: l10n.userEmail, subtitle: user.email),
                  const AppDivider(),
                  AppListTile(title: l10n.userPhone, subtitle: user.telefone),
                  const AppDivider(),
                  AppListTile(title: l10n.userStatus, subtitle: user.status),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
