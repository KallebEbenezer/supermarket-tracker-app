import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/repositories/bank_account_repository.dart';
import '../datasources/bank_account_remote_data_source.dart';

class BankAccountRepositoryImpl implements BankAccountRepository {
  BankAccountRepositoryImpl(this._remote);

  final BankAccountRemoteDataSource _remote;

  @override
  Future<List<BankAccountEntity>> listBankAccounts(String empresaId) async {
    try {
      final envelope = await _remote.listBankAccounts(empresaId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<BankAccountEntity> createBankAccount(
    Map<String, dynamic> payload,
  ) async {
    try {
      final envelope = await _remote.createBankAccount(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<BankAccountEntity> updateBankAccount(
    String id,
    Map<String, dynamic> payload,
  ) async {
    try {
      final envelope = await _remote.updateBankAccount(id, payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<void> deleteBankAccount(String id) async {
    try {
      await _remote.deleteBankAccount(id);
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
