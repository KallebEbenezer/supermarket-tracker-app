import '../../../../core/api/models/api_envelope.dart';
import '../../domain/entities/bank_account_entity.dart';

/// Interface that defines the data-source operations for bank accounts.
abstract class BankAccountRemoteDataSource {
  /// List bank accounts for a given company.
  Future<ApiEnvelope<List<BankAccountEntity>>> listBankAccounts(
    String empresaId,
  );

  /// Create a new bank account.
  Future<ApiEnvelope<BankAccountEntity>> createBankAccount(
    Map<String, dynamic> payload,
  );

  /// Update an existing bank account.
  Future<ApiEnvelope<BankAccountEntity>> updateBankAccount(
    String id,
    Map<String, dynamic> payload,
  );

  /// Delete a bank account.
  Future<void> deleteBankAccount(String id);
}
