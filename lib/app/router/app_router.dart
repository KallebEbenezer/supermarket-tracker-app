import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../design_system/tokens/app_icons.dart';
import '../../features/_shared/presentation/providers/repository_providers.dart';
import '../../features/app_shell/presentation/widgets/app_shell_scaffold.dart';
import '../../features/app_shell/presentation/widgets/coming_soon_screen.dart';
import '../../features/auth/presentation/screens/forgot_password_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/reset_password_screen.dart';
import '../../features/auth/presentation/screens/signup_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/store/presentation/screens/store_create_screen.dart';
import '../../features/store/presentation/screens/store_detail_screen.dart';
import '../../features/store/presentation/screens/store_list_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';
import '../../features/product/presentation/screens/product_create_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/customer/presentation/screens/customer_list_screen.dart';
import '../../features/customer/presentation/screens/customer_detail_screen.dart';
import '../../features/customer/presentation/screens/customer_create_screen.dart';
import '../../features/user/presentation/screens/user_list_screen.dart';
import '../../features/user/presentation/screens/user_detail_screen.dart';
import '../../features/user/presentation/screens/user_create_screen.dart';
import '../l10n/app_localizations.dart';

/// Rotas públicas de autenticação (acessíveis sem sessão).
const _publicRoutes = {
  '/login',
  '/signup',
  '/forgot-password',
  '/reset-password',
};

/// Roteador central da aplicação.
///
/// - `ShellRoute` mantém a estrutura (barra inferior + drawer) nas telas autenticadas.
/// - `redirect` implementa o portão de sessão: sem credenciais → `/login`;
///   com credenciais em rota de autenticação → `/dashboard`.
/// - `refreshListenable` reavalia o redirecionamento quando [SessionManager]
///   notifica mudança de autenticação (ex.: login/logout/refresh expirado).
final appRouterProvider = Provider<GoRouter>((ref) {
  final sessionManager = ref.read(sessionManagerProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    refreshListenable: sessionManager.isAuthenticated,
    redirect: (context, state) {
      final authenticated = sessionManager.isAuthenticated.value;
      final location = state.matchedLocation;
      final isPublic = _publicRoutes.contains(location);
      if (!authenticated && !isPublic) return '/login';
      if (authenticated && isPublic) return '/dashboard';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/reset-password',
        builder: (context, state) => const ResetPasswordScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            AppShellScaffold(state: state, child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/stores',
            builder: (context, state) => const StoreListScreen(),
          ),
          GoRoute(
            path: '/stores/new',
            builder: (context, state) => const StoreCreateScreen(),
          ),
          GoRoute(
            path: '/stores/:id',
            builder: (context, state) => StoreDetailScreen(
              storeId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '/products',
            builder: (context, state) => const ProductListScreen(),
          ),
          GoRoute(
            path: '/products/new',
            builder: (context, state) => const ProductCreateScreen(),
          ),
          GoRoute(
            path: '/products/:id',
            builder: (context, state) => ProductDetailScreen(
              productId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '/sales',
            builder: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              return ComingSoonScreen(title: l10n.navSales, icon: AppIcons.sales);
            },
          ),
          GoRoute(
            path: '/stock',
            builder: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              return ComingSoonScreen(title: l10n.navStock, icon: AppIcons.stock);
            },
          ),
          GoRoute(
            path: '/cash',
            builder: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              return ComingSoonScreen(title: l10n.navCash, icon: AppIcons.cash);
            },
          ),
          GoRoute(
            path: '/customers',
            builder: (context, state) => const CustomerListScreen(),
          ),
          GoRoute(
            path: '/customers/new',
            builder: (context, state) => const CustomerCreateScreen(),
          ),
          GoRoute(
            path: '/customers/:id',
            builder: (context, state) => CustomerDetailScreen(
              customerId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '/users',
            builder: (context, state) => const UserListScreen(),
          ),
          GoRoute(
            path: '/users/new',
            builder: (context, state) => const UserCreateScreen(),
          ),
          GoRoute(
            path: '/users/:id',
            builder: (context, state) => UserDetailScreen(
              userId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '/company',
            builder: (context, state) {
              final l10n = AppLocalizations.of(context)!;
              return ComingSoonScreen(title: l10n.navCompany, icon: AppIcons.business);
            },
          ),
        ],
      ),
    ],
  );
});
