import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../design_system/tokens/app_icons.dart';

/// Destino de navegação da aplicação.
class NavDestination {
  const NavDestination({
    required this.id,
    required this.label,
    required this.icon,
    required this.route,
    this.primary = false,
    this.fab,
  });

  final String id;
  final String Function(AppLocalizations l10n) label;
  final IconData icon;
  final String route;
  final bool primary;

  /// FAB exibido pela estrutura quando esta rota está ativa (opcional).
  final Widget? Function(BuildContext context)? fab;
}

/// Todas as seções da aplicação.
///
/// `primary == true` aparecem na barra inferior; as demais ficam no menu
/// "Mais" (drawer). Esta lista é a fonte única de verdade para o [AppShellScaffold]
/// e para o roteador.
final List<NavDestination> kNavDestinations = [
  NavDestination(
    id: 'dashboard',
    label: (l10n) => l10n.dashboardTitle,
    icon: AppIcons.dashboard,
    route: '/dashboard',
    // Dashboard acessível via ícone no AppBar (não na barra inferior)
  ),
  NavDestination(
    id: 'stores',
    label: (l10n) => l10n.storesTitle,
    icon: AppIcons.store,
    route: '/stores',
    fab: (context) => FloatingActionButton(
      onPressed: () => context.go('/stores/new'),
      tooltip: 'Nova loja',
      child: const Icon(AppIcons.add),
    ),
  ),
  NavDestination(
    id: 'sales',
    label: (l10n) => l10n.navSales,
    icon: AppIcons.sales,
    route: '/sales',
    primary: true,
  ),
  NavDestination(
    id: 'products',
    label: (l10n) => l10n.navProducts,
    icon: AppIcons.inventory,
    route: '/products',
    primary: true,
    fab: (context) => FloatingActionButton(
      onPressed: () => context.go('/products/new'),
      tooltip: 'Novo produto',
      child: const Icon(AppIcons.add),
    ),
  ),
  NavDestination(
    id: 'stock',
    label: (l10n) => l10n.navStock,
    icon: AppIcons.stock,
    route: '/stock',
    // Estoque no drawer "Mais"
  ),
  NavDestination(
    id: 'cash',
    label: (l10n) => l10n.navCash,
    icon: AppIcons.cash,
    route: '/cash',
    primary: true,
  ),
  NavDestination(
    id: 'customers',
    label: (l10n) => l10n.navCustomers,
    icon: AppIcons.customers,
    route: '/customers',
    primary: true,
    fab: (context) => FloatingActionButton(
      onPressed: () => context.go('/customers/new'),
      tooltip: 'Novo cliente',
      child: const Icon(AppIcons.add),
    ),
  ),
  NavDestination(
    id: 'users',
    label: (l10n) => l10n.navUsers,
    icon: AppIcons.person,
    route: '/users',
    fab: (context) => FloatingActionButton(
      onPressed: () => context.go('/users/new'),
      tooltip: 'Novo usuário',
      child: const Icon(AppIcons.add),
    ),
  ),
  NavDestination(
    id: 'company',
    label: (l10n) => l10n.navCompany,
    icon: AppIcons.business,
    route: '/company',
  ),
];

List<NavDestination> get primaryDestinations =>
    kNavDestinations.where((d) => d.primary).toList();

List<NavDestination> get drawerDestinations =>
    kNavDestinations.where((d) => !d.primary).toList();

/// Retorna o destino cuja rota corresponde (ou é prefixo de) [location.
NavDestination? destinationForLocation(String location) {
  for (final d in kNavDestinations) {
    if (location == d.route || location.startsWith('${d.route}/')) {
      return d;
    }
  }
  return null;
}
