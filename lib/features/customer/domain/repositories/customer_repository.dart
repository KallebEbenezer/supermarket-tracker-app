import '../entities/customer_entity.dart';

/// Contrato de domínio para operações de cliente.
abstract class CustomerRepository {
  Future<CustomerEntity> createCustomer(Map<String, dynamic> payload);
}
