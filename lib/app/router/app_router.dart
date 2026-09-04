import 'package:flutter/foundation.dart';
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
import '../../features/cash_register/presentation/screens/bank_account_form_screen.dart';
import '../../features/cash_register/presentation/screens/bank_account_list_screen.dart';
import '../../features/cash_register/presentation/screens/cash_register_create_screen.dart';
import '../../features/cash_register/presentation/screens/cash_register_detail_screen.dart';
import '../../features/cash_register/presentation/screens/cash_register_list_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/store/presentation/screens/store_create_screen.dart';
import '../../features/store/presentation/screens/store_detail_screen.dart';
import '../../features/store/presentation/screens/store_list_screen.dart';
import '../../features/product/presentation/screens/product_list_screen.dart';
import '../../features/product/presentation/screens/product_create_screen.dart';
import '../../features/product/presentation/screens/product_detail_screen.dart';
import '../../features/product/presentation/screens/barcode_scanner_screen.dart';
import '../../features/product/presentation/screens/product_photo_capture_screen.dart';
import '../../features/customer/presentation/screens/customer_list_screen.dart';
import '../../features/customer/presentation/screens/customer_detail_screen.dart';
import '../../features/customer/presentation/screens/customer_create_screen.dart';
import '../../features/user/presentation/screens/user_list_screen.dart';
import '../../features/user/presentation/screens/user_detail_screen.dart';
import '../../features/user/presentation/screens/user_create_screen.dart';
import '../../features/stock_movement/presentation/screens/stock_movement_list_screen.dart';
import '../../features/stock_movement/presentation/screens/stock_movement_create_screen.dart';
import '../../features/sale/presentation/screens/sale_list_screen.dart';
import '../../features/sale/presentation/screens/sale_scan_screen.dart';
import '../../features/sale/presentation/screens/sale_summary_screen.dart';
import '../../features/sale/presentation/screens/sale_pix_screen.dart';
import '../../features/sale/presentation/screens/payment_method_screen.dart';
import '../../features/sale/presentation/screens/payment_pix_screen.dart';
import '../../features/sale/presentation/screens/payment_card_screen.dart';
import '../../features/sale/presentation/screens/payment_cash_screen.dart';
import '../../features/sale/presentation/screens/sale_confirmation_screen.dart';
import '../../features/company/presentation/screens/company_create_screen.dart';
import '../../features/company/presentation/screens/company_list_screen.dart';
import '../l10n/app_localizations.dart';

/// Combina [ValueNotifier]s em um único [Listenable] para o router.
class _CombinedNotifier extends ChangeNotifier {
  _CombinedNotifier(this._notifiers) {
    for (final n in _notifiers) {
      n.addListener(_onChanged);
    }
  }
  final List<ValueNotifier<bool>> _notifiers;
  void _onChanged() => notifyListeners();
  @override
  void dispose() {
    for (final n in _notifiers) {
      n.removeListener(_onChanged);
    }
    super.dispose();
  }
}

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
    refreshListenable: _CombinedNotifier([
      sessionManager.isAuthenticated,
      sessionManager.empresaIdChanged,
      sessionManager.lojaChanged,
    ]),
    redirect: (context, state) {
      final authenticated = sessionManager.isAuthenticated.value;
      final empresaId = sessionManager.empresaId;
      final lojaId = sessionManager.lojaId;
      final location = state.matchedLocation;
      final isPublic = _publicRoutes.contains(location);

      if (!authenticated && !isPublic) return '/login';
      if (authenticated && isPublic) return '/dashboard';
      if (authenticated && empresaId == null && location != '/company/new') {
        return '/company/new';
      }
      if (authenticated && empresaId != null && lojaId == null &&
          location != '/stores' && location != '/stores/new' &&
          !location.startsWith('/stores/')) {
        return '/stores';
      }
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
            path: '/products/new/scan-barcode',
            builder: (context, state) => const BarcodeScannerScreen(),
          ),
          GoRoute(
            path: '/products/new/photo',
            builder: (context, state) => const ProductPhotoCaptureScreen(),
          ),
          GoRoute(
            path: '/products/:id',
            builder: (context, state) => ProductDetailScreen(
              productId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '/products/:id/edit',
            builder: (context, state) => ProductCreateScreen(
              productId: state.pathParameters['id'] ?? '',
              editing: true,
            ),
          ),
          GoRoute(
            path: '/sales',
            builder: (context, state) => const SaleListScreen(),
            routes: [
              GoRoute(
                path: 'scan',
                builder: (context, state) => const SaleScanScreen(),
              ),
              GoRoute(
                path: 'summary',
                builder: (context, state) => const SaleSummaryScreen(),
                routes: [
                  GoRoute(
                    path: 'payment-method',
                    builder: (context, state) => const PaymentMethodScreen(),
                  ),
                  GoRoute(
                    path: 'payment-pix',
                    builder: (context, state) => const PaymentPixScreen(),
                  ),
                  GoRoute(
                    path: 'payment-card',
                    builder: (context, state) => const PaymentCardScreen(),
                  ),
                  GoRoute(
                    path: 'payment-cash',
                    builder: (context, state) => const PaymentCashScreen(),
                  ),
                ],
              ),
              GoRoute(
                path: 'pix',
                builder: (context, state) {
                  final sale = state.extra as dynamic;
                  return SalePixScreen(sale: sale);
                },
              ),
              GoRoute(
                path: 'confirmation',
                builder: (context, state) {
                  final sale = state.extra as dynamic;
                  return SaleConfirmationScreen(sale: sale);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/stock',
            builder: (context, state) => const StockMovementListScreen(),
          ),
          GoRoute(
            path: '/cash',
            builder: (context, state) => const CashRegisterListScreen(),
          ),
          GoRoute(
            path: '/cash/new',
            builder: (context, state) => const CashRegisterCreateScreen(),
          ),
          GoRoute(
            path: '/cash/:id',
            builder: (context, state) => CashRegisterDetailScreen(
              cashRegisterId: state.pathParameters['id'] ?? '',
            ),
          ),
          GoRoute(
            path: '/cash/:id/link-bank',
            builder: (context, state) => const BankAccountFormScreen(),
          ),
          GoRoute(
            path: '/cash/bank-accounts',
            builder: (context, state) => const BankAccountListScreen(),
          ),
          GoRoute(
            path: '/cash/bank-accounts/new',
            builder: (context, state) => const BankAccountFormScreen(),
          ),
          GoRoute(
            path: '/cash/bank-accounts/:id/edit',
            builder: (context, state) => BankAccountFormScreen(
              accountId: state.pathParameters['id'] ?? '',
              editing: true,
            ),
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
            builder: (context, state) => const CompanyListScreen(),
          ),
          GoRoute(
            path: '/company/new',
            builder: (context, state) => const CompanyCreateScreen(),
          ),
        ],
      ),
    ],
  );
});
