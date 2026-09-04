import '../../../../core/api/models/api_envelope.dart';
import '../../../../core/network/api_client.dart';
import '../../domain/entities/payment_entity.dart';
import '../../domain/entities/pix_payment_entity.dart';
import '../../domain/entities/sale_entity.dart';
import '../mappers/sale_mapper.dart';
import 'sale_remote_data_source.dart';

/// Implementação do [SaleRemoteDataSource] baseada na API OpenAPI do backend.
class OpenApiSaleRemoteDataSource implements SaleRemoteDataSource {
  OpenApiSaleRemoteDataSource(
    this._client,
    this._mapper,
  );

  final ApiClient _client;
  final SaleMapper _mapper;

  @override
  Future<ApiEnvelope<List<SaleEntity>>> listSales(
    String companyId, {
    String? storeId,
    int? limit,
  }) =>
      _client.get(
        '/api/v1/vendas',
        queryParameters: {
          'empresaId': companyId,
          if (storeId != null) 'lojaId': storeId,
          if (limit != null) 'limite': limit,
        },
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJsonList(value as List<dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<SaleEntity>> finalizeSale(Map<String, dynamic> payload) =>
      _client.post(
        '/api/v1/vendas/finalizar',
        data: payload,
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<SaleEntity>> getSale(String saleId) => _client.get(
        '/api/v1/vendas/$saleId',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => _mapper.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<List<PaymentEntity>>> listPayments(String saleId) =>
      _client.get(
        '/api/v1/vendas/$saleId/pagamentos',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => (value as List<dynamic>)
              .map((e) => PaymentEntity.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );

  @override
  Future<ApiEnvelope<PixPaymentEntity>> getPixDetails(String saleId) =>
      _client.get(
        '/api/v1/vendas/$saleId/pix',
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => PixPaymentEntity.fromJson(value as Map<String, dynamic>),
        ),
      );

  @override
  Future<ApiEnvelope<Map<String, dynamic>>> processCardPayment({
    required String vendaId,
    String? contaBancariaId,
    required double valor,
    required String modalidade,
    int parcelas = 1,
    String? referenciaNfc,
  }) =>
      _client.post(
        '/api/v1/pagamentos/cartao',
        data: {
          'vendaId': vendaId,
          'contaBancariaId': contaBancariaId,
          'valor': valor,
          'modalidade': modalidade,
          'parcelas': parcelas,
          'referenciaNfc': referenciaNfc,
        },
        parser: (data) => ApiEnvelope.fromJson(
          data as Map<String, dynamic>,
          (value) => value as Map<String, dynamic>,
        ),
      );
}
