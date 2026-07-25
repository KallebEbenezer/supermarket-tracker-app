import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/customer_entity.dart';
import '../providers/customer_providers.dart';

class CustomerDetailScreen extends ConsumerWidget {
  const CustomerDetailScreen({super.key, required this.customerId});

  final String customerId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider) ?? '';
    final customers = ref.watch(customerListProvider(empresaId));

    return AsyncScreen<List<CustomerEntity>>(
      state: customers,
      onRetry: () => ref.invalidate(customerListProvider(empresaId)),
      dataBuilder: (context, list) {
        final customer = list.where((c) => c.id == customerId).firstOrNull;
        if (customer == null) {
          return Center(child: Text(l10n.genericError));
        }
        return ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            AppCard(
              child: Column(
                children: [
                  AppListTile(title: l10n.customerName, subtitle: customer.nome),
                  const AppDivider(),
                  AppListTile(
                      title: l10n.customerCpfCnpj,
                      subtitle: customer.cpfCnpj),
                  const AppDivider(),
                  AppListTile(title: l10n.customerEmail, subtitle: customer.email),
                  const AppDivider(),
                  AppListTile(
                      title: l10n.customerPhone, subtitle: customer.telefone),
                  const AppDivider(),
                  AppListTile(
                    title: l10n.customerBirthDate,
                    subtitle: customer.dataNascimento,
                  ),
                  const AppDivider(),
                  AppListTile(
                      title: l10n.customerStatus, subtitle: customer.status),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
