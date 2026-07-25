import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/design_system.dart';
import '../../../_shared/presentation/providers/company_provider.dart';
import '../../../_shared/presentation/widgets/async_screen.dart';
import '../../domain/entities/dashboard_entity.dart';
import '../providers/dashboard_provider.dart';

String _brl(double value) =>
    NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(value);

/// Tela de visão geral (Painel) da empresa.
class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final empresaId = ref.watch(currentCompanyIdProvider) ?? '';
    final dashboard = ref.watch(dashboardProvider(empresaId));

    return AsyncScreen<DashboardEntity>(
      state: dashboard,
      onRetry: () => ref.invalidate(dashboardProvider(empresaId)),
      dataBuilder: (context, data) => ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: AppSpacing.sm,
            crossAxisSpacing: AppSpacing.sm,
            childAspectRatio: 1.6,
            children: [
              _KpiCard(label: l10n.dashboardRevenue, value: _brl(data.totalVendidoMes)),
              _KpiCard(label: l10n.dashboardProfit, value: _brl(data.lucroMes)),
              _KpiCard(label: l10n.dashboardLoss, value: _brl(data.prejuizoMes)),
              _KpiCard(label: l10n.dashboardTicket, value: _brl(data.ticketMedioMes)),
              _KpiCard(
                label: l10n.dashboardSalesToday,
                value: data.vendasDoDia.toString(),
              ),
              _KpiCard(
                label: l10n.dashboardSalesMonth,
                value: data.vendasDoMes.toString(),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionList(title: l10n.dashboardLatestSales, items: data.ultimasVendas),
          const SizedBox(height: AppSpacing.lg),
          _SectionList(
            title: l10n.dashboardTopProducts,
            items: data.produtosMaisVendidos,
          ),
          const SizedBox(height: AppSpacing.lg),
          _SectionList(title: l10n.dashboardLowStock, items: data.estoqueBaixo),
        ],
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  const _KpiCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              value,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      );
}

class _SectionList extends StatelessWidget {
  const _SectionList({required this.title, required this.items});

  final String title;
  final List<Map<String, dynamic>> items;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: AppSpacing.xs, bottom: AppSpacing.xs),
            child: Text(title, style: Theme.of(context).textTheme.titleMedium),
          ),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.only(left: AppSpacing.xs),
              child: Text('—'),
            )
          else
            AppCard(
              padding: EdgeInsets.zero,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: items.length,
                separatorBuilder: (_, index) => const AppDivider(),
                itemBuilder: (context, index) {
                  final item = items[index];
                  final description = _describe(item);
                  return AppListTile(
                    title: description.title,
                    subtitle: description.subtitle,
                  );
                },
              ),
            ),
        ],
      );

  ({String title, String? subtitle}) _describe(Map<String, dynamic> item) {
    final title = item['nome'] ??
        item['produto'] ??
        item['descricao'] ??
        item['cliente'] ??
        item['id'] ??
        'Item';
    final parts = [
      if (item['valor'] != null) _brl((item['valor'] as num).toDouble()),
      if (item['total'] != null) _brl((item['total'] as num).toDouble()),
      if (item['quantidade'] != null) 'Qtd: ${item['quantidade']}',
      if (item['status'] != null) item['status'].toString(),
    ];
    return (title: title.toString(), subtitle: parts.isEmpty ? null : parts.join(' • '));
  }
}
