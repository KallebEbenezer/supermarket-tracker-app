import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Roteador central. Features futuras registram suas rotas neste ponto.
final appRouterProvider = Provider<GoRouter>(
  (ref) => GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const _ApplicationSurface(),
      ),
    ],
  ),
);

/// Superfície neutra enquanto a primeira feature ainda não existe.
class _ApplicationSurface extends StatelessWidget {
  const _ApplicationSurface();

  @override
  Widget build(BuildContext context) => const SizedBox.expand();
}
