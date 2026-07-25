import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/customer_entity.dart';

/// Interface that defines the data‑source operations for customers.
abstract class CustomerRemoteDataSource {
  /// List customers for a given company.
  Future<ApiEnvelope<List<CustomerEntity>>> listCustomers(String companyId);

  /// Create a new customer.
  Future<ApiEnvelope<CustomerEntity>> createCustomer(Map<String, dynamic> payload);
}
