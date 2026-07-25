import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:logger/logger.dart';

import '../../core/connectivity/connectivity_service.dart';
import '../../core/cache/cache_service.dart';
import '../../core/environment/app_environment.dart';
import '../../core/logging/app_logger.dart';
import '../../core/network/api_client.dart';
import '../../core/network/network_module.dart';
import '../../core/network/network_request_monitor.dart';
import '../../core/session/session_manager.dart';
import '../../core/storage/secure_storage.dart';
import '../../core/storage/storage_service.dart';
import '../../features/cash_register/data/datasources/cash_register_remote_data_source.dart';
import '../../features/cash_register/data/datasources/openapi_cash_register_remote_data_source.dart';
import '../../features/cash_register/data/mappers/cash_register_mapper.dart';
import '../../features/cash_register/data/repositories/cash_register_repository_impl.dart';
import '../../features/cash_register/domain/repositories/cash_register_repository.dart';
import '../../features/company/data/datasources/company_remote_data_source.dart';
import '../../features/company/data/datasources/openapi_company_remote_data_source.dart';
import '../../features/company/data/mappers/company_mapper.dart';
import '../../features/company/data/repositories/company_repository_impl.dart';
import '../../features/company/domain/repositories/company_repository.dart';
import '../../features/customer/data/datasources/customer_remote_data_source.dart';
import '../../features/customer/data/datasources/openapi_customer_remote_data_source.dart';
import '../../features/customer/data/mappers/customer_mapper.dart';
import '../../features/customer/data/repositories/customer_repository_impl.dart';
import '../../features/customer/domain/repositories/customer_repository.dart';
import '../../features/dashboard/data/datasources/dashboard_remote_data_source.dart';
import '../../features/dashboard/data/datasources/openapi_dashboard_remote_data_source.dart';
import '../../features/dashboard/data/mappers/dashboard_mapper.dart';
import '../../features/dashboard/data/repositories/dashboard_repository_impl.dart';
import '../../features/dashboard/domain/repositories/dashboard_repository.dart';
import '../../features/product/data/datasources/openapi_product_remote_data_source.dart';
import '../../features/product/data/datasources/product_remote_data_source.dart';
import '../../features/product/data/mappers/product_mapper.dart';
import '../../features/product/data/repositories/product_repository_impl.dart';
import '../../features/product/domain/repositories/product_repository.dart';
import '../../features/sale/data/datasources/openapi_sale_remote_data_source.dart';
import '../../features/sale/data/datasources/sale_remote_data_source.dart';
import '../../features/sale/data/mappers/sale_mapper.dart';
import '../../features/sale/data/repositories/sale_repository_impl.dart';
import '../../features/sale/domain/repositories/sale_repository.dart';
import '../../features/stock_movement/data/datasources/openapi_stock_movement_remote_data_source.dart';
import '../../features/stock_movement/data/datasources/stock_movement_remote_data_source.dart';
import '../../features/stock_movement/data/mappers/stock_movement_mapper.dart';
import '../../features/stock_movement/data/repositories/stock_movement_repository_impl.dart';
import '../../features/stock_movement/domain/repositories/stock_movement_repository.dart';
import '../../features/store/data/datasources/openapi_store_remote_data_source.dart';
import '../../features/store/data/datasources/store_remote_data_source.dart';
import '../../features/store/data/mappers/store_mapper.dart';
import '../../features/store/data/repositories/store_repository_impl.dart';
import '../../features/store/domain/repositories/store_repository.dart';
import '../../features/user/data/datasources/openapi_user_remote_data_source.dart';
import '../../features/user/data/datasources/user_remote_data_source.dart';
import '../../features/user/data/mappers/user_mapper.dart';
import '../../features/user/data/repositories/user_repository_impl.dart';
import '../../features/user/domain/repositories/user_repository.dart';
import '../../features/auth/data/datasources/auth_remote_data_source.dart';
import '../../features/auth/data/datasources/openapi_auth_remote_data_source.dart';
import '../../features/auth/data/mappers/auth_mapper.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';

final getIt = GetIt.instance;

final appEnvironmentProvider = Provider<AppEnvironment>(
  (ref) => getIt<AppEnvironment>(),
);

/// Ponto único para registrar dependências de infraestrutura e features.
void configureDependencies(AppEnvironment environment) {
  if (getIt.isRegistered<AppEnvironment>()) {
    getIt.unregister<AppEnvironment>();
  }
  if (getIt.isRegistered<Logger>()) {
    getIt.unregister<Logger>();
  }

  final logger = createAppLogger(environment);
  setAppLogger(logger);

  getIt
    ..registerSingleton<AppEnvironment>(environment)
    ..registerSingleton<Logger>(logger)
    ..registerLazySingleton<SecureStorage>(FlutterSecureStorageService.new)
    ..registerLazySingleton<StorageService>(StorageService.new)
    ..registerLazySingleton<SessionManager>(
      () => SessionManager(getIt<SecureStorage>()),
    )
    ..registerLazySingleton<ConnectivityService>(ConnectivityService.new)
    ..registerLazySingleton<CacheService>(CacheService.new)
    ..registerLazySingleton<NetworkRequestMonitor>(NetworkRequestMonitor.new)
    ..registerLazySingleton<Dio>(
      () => NetworkModule.createDio(
        environment: getIt<AppEnvironment>(),
        sessionManager: getIt<SessionManager>(),
        connectivity: getIt<ConnectivityService>(),
        cache: getIt<CacheService>(),
        logger: getIt<Logger>(),
        monitor: getIt<NetworkRequestMonitor>(),
      ),
    )
    ..registerLazySingleton<ApiClient>(
      () => NetworkModule.createApiClient(getIt<Dio>()),
    )
    // --- Stores ---
    ..registerLazySingleton<StoreMapper>(StoreMapper.new)
    ..registerLazySingleton<StoreRemoteDataSource>(
      () => OpenApiStoreRemoteDataSource(
        getIt<ApiClient>(),
        getIt<StoreMapper>(),
      ),
    )
    ..registerLazySingleton<StoreRepository>(
      () => StoreRepositoryImpl(getIt<StoreRemoteDataSource>()),
    )
    // --- Company ---
    ..registerLazySingleton<CompanyMapper>(CompanyMapper.new)
    ..registerLazySingleton<CompanyRemoteDataSource>(
      () => OpenApiCompanyRemoteDataSource(
        getIt<ApiClient>(),
        getIt<CompanyMapper>(),
      ),
    )
    ..registerLazySingleton<CompanyRepository>(
      () => CompanyRepositoryImpl(getIt<CompanyRemoteDataSource>()),
    )
    // --- Product ---
    ..registerLazySingleton<ProductMapper>(ProductMapper.new)
    ..registerLazySingleton<ProductRemoteDataSource>(
      () => OpenApiProductRemoteDataSource(
        getIt<ApiClient>(),
        getIt<ProductMapper>(),
      ),
    )
    ..registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(getIt<ProductRemoteDataSource>()),
    )
    // --- Customer ---
    ..registerLazySingleton<CustomerMapper>(CustomerMapper.new)
    ..registerLazySingleton<CustomerRemoteDataSource>(
      () => OpenApiCustomerRemoteDataSource(
        getIt<ApiClient>(),
        getIt<CustomerMapper>(),
      ),
    )
    ..registerLazySingleton<CustomerRepository>(
      () => CustomerRepositoryImpl(getIt<CustomerRemoteDataSource>()),
    )
    // --- User ---
    ..registerLazySingleton<UserMapper>(UserMapper.new)
    ..registerLazySingleton<UserRemoteDataSource>(
      () => OpenApiUserRemoteDataSource(
        getIt<ApiClient>(),
        getIt<UserMapper>(),
      ),
    )
    ..registerLazySingleton<UserRepository>(
      () => UserRepositoryImpl(getIt<UserRemoteDataSource>()),
    )
    // --- Cash Register ---
    ..registerLazySingleton<CashRegisterMapper>(CashRegisterMapper.new)
    ..registerLazySingleton<CashRegisterRemoteDataSource>(
      () => OpenApiCashRegisterRemoteDataSource(
        getIt<ApiClient>(),
        getIt<CashRegisterMapper>(),
      ),
    )
    ..registerLazySingleton<CashRegisterRepository>(
      () => CashRegisterRepositoryImpl(getIt<CashRegisterRemoteDataSource>()),
    )
    // --- Stock Movement ---
    ..registerLazySingleton<StockMovementMapper>(StockMovementMapper.new)
    ..registerLazySingleton<StockMovementRemoteDataSource>(
      () => OpenApiStockMovementRemoteDataSource(
        getIt<ApiClient>(),
        getIt<StockMovementMapper>(),
      ),
    )
    ..registerLazySingleton<StockMovementRepository>(
      () => StockMovementRepositoryImpl(getIt<StockMovementRemoteDataSource>()),
    )
    // --- Sale ---
    ..registerLazySingleton<SaleMapper>(SaleMapper.new)
    ..registerLazySingleton<SaleRemoteDataSource>(
      () => OpenApiSaleRemoteDataSource(
        getIt<ApiClient>(),
        getIt<SaleMapper>(),
      ),
    )
    ..registerLazySingleton<SaleRepository>(
      () => SaleRepositoryImpl(getIt<SaleRemoteDataSource>()),
    )
    // --- Dashboard ---
    ..registerLazySingleton<DashboardMapper>(DashboardMapper.new)
    ..registerLazySingleton<DashboardRemoteDataSource>(
      () => OpenApiDashboardRemoteDataSource(
        getIt<ApiClient>(),
        getIt<DashboardMapper>(),
      ),
    )
    ..registerLazySingleton<DashboardRepository>(
      () => DashboardRepositoryImpl(getIt<DashboardRemoteDataSource>()),
    )
    // --- Auth ---
    ..registerLazySingleton<AuthMapper>(AuthMapper.new)
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => OpenApiAuthRemoteDataSource(
        getIt<ApiClient>(),
        getIt<AuthMapper>(),
      ),
    )
    ..registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        getIt<AuthRemoteDataSource>(),
        getIt<SessionManager>(),
      ),
    );
}