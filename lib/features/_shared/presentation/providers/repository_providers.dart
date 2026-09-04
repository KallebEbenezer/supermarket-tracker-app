import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/session/session_manager.dart';
import '../../../cash_register/domain/repositories/bank_account_repository.dart';
import '../../../cash_register/domain/repositories/cash_register_repository.dart';
import '../../../company/domain/repositories/company_repository.dart';
import '../../../customer/domain/repositories/customer_repository.dart';
import '../../../dashboard/domain/repositories/dashboard_repository.dart';
import '../../../product/domain/repositories/product_repository.dart';
import '../../../sale/domain/repositories/sale_repository.dart';
import '../../../stock_movement/domain/repositories/stock_movement_repository.dart';
import '../../../store/domain/repositories/store_repository.dart';
import '../../../user/domain/repositories/user_repository.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

/// Ponte entre o container de DI (get_it) e o Riverpod.
///
/// As features registram suas implementações em [getIt] (ver `injection.dart`).
/// A camada de apresentação nunca importa `get_it` diretamente — ela consome
/// estes [Provider]s, seguindo o mesmo padrão de `appEnvironmentProvider`.
final getItInstance = GetIt.instance;

final dashboardRepositoryProvider = Provider<DashboardRepository>(
  (ref) => getItInstance<DashboardRepository>(),
);

final storeRepositoryProvider = Provider<StoreRepository>(
  (ref) => getItInstance<StoreRepository>(),
);

final productRepositoryProvider = Provider<ProductRepository>(
  (ref) => getItInstance<ProductRepository>(),
);

final saleRepositoryProvider = Provider<SaleRepository>(
  (ref) => getItInstance<SaleRepository>(),
);

final customerRepositoryProvider = Provider<CustomerRepository>(
  (ref) => getItInstance<CustomerRepository>(),
);

final companyRepositoryProvider = Provider<CompanyRepository>(
  (ref) => getItInstance<CompanyRepository>(),
);

final userRepositoryProvider = Provider<UserRepository>(
  (ref) => getItInstance<UserRepository>(),
);

final cashRegisterRepositoryProvider = Provider<CashRegisterRepository>(
  (ref) => getItInstance<CashRegisterRepository>(),
);

final bankAccountRepositoryProvider = Provider<BankAccountRepository>(
  (ref) => getItInstance<BankAccountRepository>(),
);

final stockMovementRepositoryProvider = Provider<StockMovementRepository>(
  (ref) => getItInstance<StockMovementRepository>(),
);

final sessionManagerProvider = Provider<SessionManager>(
  (ref) => getItInstance<SessionManager>(),
);

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => getItInstance<AuthRepository>(),
);
