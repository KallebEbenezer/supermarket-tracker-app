import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../providers/bank_account_provider.dart';

/// Lista de contas bancárias (rota `/cash/bank-accounts`).
class BankAccountListScreen extends ConsumerWidget {
  const BankAccountListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider) ?? '';
    final bankAccounts = ref.watch(bankAccountListProvider(empresaId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bankAccount)),
      body: AsyncScreen<List<BankAccountEntity>>(
        state: bankAccounts,
        isEmpty: (list) => list.isEmpty,
        emptyTitle: l10n.noBankAccounts,
        emptyMessage: l10n.createBankAccountMessage,
        onRetry: () => ref.invalidate(bankAccountListProvider(empresaId)),
        dataBuilder: (context, list) => RefreshIndicator(
          onRefresh: () async =>
              ref.invalidate(bankAccountListProvider(empresaId)),
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
            itemCount: list.length,
            separatorBuilder: (_, index) => const AppDivider(),
            itemBuilder: (context, index) {
              final account = list[index];
              return AppListTile(
                title: '${account.bancoNome} • ${account.conta}',
                subtitle:
                    '${account.agencia} • ${account.titularNome}'
                    '${account.principal ? ' • Principal' : ''}',
                onTap: () =>
                    context.go('/cash/bank-accounts/${account.id}/edit'),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/cash/bank-accounts/new'),
        child: const Icon(AppIcons.add),
      ),
    );
  }
}
