import '../../../../core/errors/app_exception.dart';
import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/cash_register_entity.dart';
import '../../domain/entities/cash_session_entity.dart';
import '../../domain/repositories/cash_register_repository.dart';
import '../datasources/cash_register_remote_data_source.dart';

class CashRegisterRepositoryImpl implements CashRegisterRepository {
  CashRegisterRepositoryImpl(this._remote);

  final CashRegisterRemoteDataSource _remote;

  @override
  Future<CashRegisterEntity> createCashRegister(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.createCashRegister(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<List<CashRegisterEntity>> listCashRegisters(String storeId) async {
    try {
      final envelope = await _remote.listCashRegisters(storeId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<CashSessionEntity> openCashSession(
    String cashRegisterId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final envelope = await _remote.openCashSession(cashRegisterId, payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<CashSessionEntity> closeCurrentCashSession(
    String cashRegisterId,
    Map<String, dynamic> payload,
  ) async {
    try {
      final envelope = await _remote.closeCurrentCashSession(cashRegisterId, payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<CashSessionEntity?> getCurrentCashSession(
    String cashRegisterId,
  ) async {
    try {
      final envelope = await _remote.getCurrentCashSession(cashRegisterId);
      return envelope.requireData();
    } on NotFoundException {
      // Sem sessão aberta: o endpoint responde 404.
      return null;
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
