import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/dashboard_entity.dart';

/// Interface that defines the data‑source operations for dashboards.
abstract class DashboardRemoteDataSource {
  /// Retrieve the aggregated dashboard data for a given company.
  Future<ApiEnvelope<DashboardEntity>> getDashboard({
    required String companyId,
    String? storeId,
    int limit = 10,
  });
}
