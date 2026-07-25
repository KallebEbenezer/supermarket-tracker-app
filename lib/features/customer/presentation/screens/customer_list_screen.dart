import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/customer_entity.dart';
import '../providers/customer_providers.dart';

class CustomerListScreen extends ConsumerWidget {
  const CustomerListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider) ?? '';
    final customers = ref.watch(customerListProvider(empresaId));

    return AsyncScreen<List<CustomerEntity>>(
      state: customers,
      isEmpty: (list) => list.isEmpty,
      emptyMessage: l10n.noCustomers,
      onRetry: () => ref.invalidate(customerListProvider(empresaId)),
      dataBuilder: (context, list) => RefreshIndicator(
        onRefresh: () async =>
            ref.invalidate(customerListProvider(empresaId)),
        child: ListView.separated(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          itemCount: list.length,
          separatorBuilder: (_, index) => const AppDivider(),
          itemBuilder: (context, index) {
            final customer = list[index];
            final subtitle = customer.email.isNotEmpty
                ? '${customer.cpfCnpj} • ${customer.email}'
                : customer.cpfCnpj;
            return AppListTile(
              title: customer.nome,
              subtitle: subtitle,
              onTap: () => context.go('/customers/${customer.id}'),
            );
          },
        ),
      ),
    );
  }
}
