import '../entities/bank_account_entity.dart';

/// Contrato de domínio para operações de conta bancária.
abstract class BankAccountRepository {
  Future<List<BankAccountEntity>> listBankAccounts(String empresaId);
  Future<BankAccountEntity> createBankAccount(Map<String, dynamic> payload);
  Future<BankAccountEntity> updateBankAccount(
    String id,
    Map<String, dynamic> payload,
  );
  Future<void> deleteBankAccount(String id);
}
