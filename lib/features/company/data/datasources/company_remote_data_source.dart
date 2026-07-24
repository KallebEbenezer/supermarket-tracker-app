import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/company_entity.dart';

/// Interface that defines the data‑source operations for companies.
abstract class CompanyRemoteDataSource {
  /// Create a new company.
  Future<ApiEnvelope<CompanyEntity>> createCompany(Map<String, dynamic> payload);
}
