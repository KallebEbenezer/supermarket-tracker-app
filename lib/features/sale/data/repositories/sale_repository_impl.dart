import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/pix_payment_entity.dart';
import '../../domain/entities/sale_entity.dart';
import '../../domain/repositories/sale_repository.dart';
import '../datasources/sale_remote_data_source.dart';

class SaleRepositoryImpl implements SaleRepository {
  SaleRepositoryImpl(this._remote);

  final SaleRemoteDataSource _remote;

  @override
  Future<List<SaleEntity>> listSales(
    String companyId, {
    String? storeId,
    int? limit,
  }) async {
    try {
      final envelope =
          await _remote.listSales(companyId, storeId: storeId, limit: limit);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<SaleEntity> finalizeSale(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.finalizeSale(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<SaleEntity> getSale(String saleId) async {
    try {
      final envelope = await _remote.getSale(saleId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<List<PaymentEntity>> listPayments(String saleId) async {
    try {
      final envelope = await _remote.listPayments(saleId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<PixPaymentEntity> getPixDetails(String saleId) async {
    try {
      final envelope = await _remote.getPixDetails(saleId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<Map<String, dynamic>> processCardPayment({
    required String vendaId,
    String? contaBancariaId,
    required double valor,
    required String modalidade,
    int parcelas = 1,
    String? referenciaNfc,
  }) async {
    try {
      final envelope = await _remote.processCardPayment(
        vendaId: vendaId,
        contaBancariaId: contaBancariaId,
        valor: valor,
        modalidade: modalidade,
        parcelas: parcelas,
        referenciaNfc: referenciaNfc,
      );
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
