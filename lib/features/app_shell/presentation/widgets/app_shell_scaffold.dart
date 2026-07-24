import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/l10n/app_localizations.dart';
import '../../../../core/session/session_manager.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../nav/nav_destinations.dart';

/// Estrutura persistente da aplicação (usada como shell do [ShellRoute]):
/// barra inferior com destinos primários + drawer "Mais" com os demais e o
/// cabeçalho do usuário (nome/e-mail/papel) + opção de sair.
class AppShellScaffold extends ConsumerWidget {
  const AppShellScaffold({
    super.key,
    required this.state,
    required this.child,
  });

  final GoRouterState state;
  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final active = destinationForLocation(state.matchedLocation);
    final primaries = primaryDestinations;
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(active?.label(l10n) ?? l10n.appName),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            _UserDrawerHeader(user: user),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  for (final d in drawerDestinations)
                    ListTile(
                      leading: Icon(d.icon),
                      title: Text(d.label(l10n)),
                      selected: active?.id == d.id,
                      onTap: () {
                        Navigator.of(context).pop();
                        context.go(d.route);
                      },
                    ),
                ],
              ),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(AppIcons.logout),
              title: Text(l10n.drawerLogout),
              onTap: () async {
                Navigator.of(context).pop();
                await ref.read(sessionManagerProvider).clear();
                if (context.mounted) context.go('/login');
              },
            ),
          ],
        ),
      ),
      body: child,
      floatingActionButton: active?.fab?.call(context),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _activePrimaryIndex(primaries, active),
        destinations: [
          for (final d in primaries)
            NavigationDestination(
              icon: Icon(d.icon),
              label: d.label(l10n),
            ),
        ],
        onDestinationSelected: (index) => context.go(primaries[index].route),
      ),
    );
  }

  int _activePrimaryIndex(List<NavDestination> primaries, NavDestination? active) {
    if (active == null) return 0;
    final index = primaries.indexWhere((d) => d.id == active.id);
    return index < 0 ? 0 : index;
  }
}

class _UserDrawerHeader extends StatelessWidget {
  const _UserDrawerHeader({this.user});

  final AuthUser? user;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return DrawerHeader(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const CircleAvatar(
            radius: 22,
            child: Icon(AppIcons.person, size: 26),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            user?.nome.isNotEmpty == true ? user!.nome : 'Usuário',
            style: theme.textTheme.titleMedium,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            user?.email ?? '',
            style: theme.textTheme.bodySmall,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          if (user?.papel != null && user!.papel!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.xs),
            Chip(
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              label: Text(user!.papel!),
            ),
          ],
        ],
      ),
    );
  }
}
