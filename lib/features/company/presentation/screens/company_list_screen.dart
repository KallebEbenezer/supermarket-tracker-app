import 'package:flutter/material.dart' hide SnackBar, OutlinedButton;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/session/session_manager.dart';
import '../../../../design_system/design_system.dart';
import '../../domain/entities/company_entity.dart';
import '../../../_shared/presentation/providers/repository_providers.dart';

final companyListProvider = FutureProvider.autoDispose<List<CompanyEntity>>((ref) async {
  final usuarioId = ref.read(sessionManagerProvider).currentUser?.id ?? '';
  final repo = ref.read(companyRepositoryProvider);
  return repo.listCompanies(usuarioId);
});

class CompanyListScreen extends ConsumerWidget {
  const CompanyListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final companies = ref.watch(companyListProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCompany)),
      body: companies.when(
        data: (list) {
          if (list.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.business, size: 56, color: AppColors.neutral90),
                  const SizedBox(height: AppSpacing.md),
                  Text(l10n.comingSoonMessage),
                  const SizedBox(height: AppSpacing.md),
                  PrimaryButton(
                    label: l10n.createCompany,
                    onPressed: () => context.push('/company/new'),
                  ),
                ],
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: list.length,
            separatorBuilder: (_, __) => const AppDivider(),
            itemBuilder: (context, index) {
              final company = list[index];
              return AppCard(
                child: ListTile(
                  title: Text(company.nomeFantasia),
                  subtitle: Text('${company.razaoSocial}\nCNPJ: ${company.cnpj}'),
                  isThreeLine: true,
                  trailing: Icon(
                    Icons.chevron_right,
                    color: AppColors.neutral90,
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.toString()),
              const SizedBox(height: AppSpacing.md),
              PrimaryButton(
                label: l10n.retry,
                onPressed: () => ref.invalidate(companyListProvider),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/company/new'),
        child: const Icon(Icons.add),
      ),
    );
  }
}
