import '../entities/dashboard_entity.dart';

/// Contrato de domínio para operações de dashboard.
abstract class DashboardRepository {
  Future<DashboardEntity> getDashboard({
    required String companyId,
    String? storeId,
    int limit = 10,
  });
}
