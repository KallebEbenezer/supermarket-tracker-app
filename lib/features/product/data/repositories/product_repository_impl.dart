import '../../../../core/errors/error_mapper.dart';
import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remote);

  final ProductRemoteDataSource _remote;

  @override
  Future<List<ProductEntity>> listProducts(String companyId) async {
    try {
      final envelope = await _remote.listProducts(companyId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<ProductEntity> createProduct(Map<String, dynamic> payload) async {
    try {
      final envelope = await _remote.createProduct(payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<ProductEntity> getProduct(String productId) async {
    try {
      final envelope = await _remote.getProduct(productId);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }

  @override
  Future<ProductEntity> updateProduct(
    String id,
    Map<String, dynamic> payload,
  ) async {
    try {
      final envelope = await _remote.updateProduct(id, payload);
      return envelope.requireData();
    } on Object catch (error) {
      throw ErrorMapper.map(error);
    }
  }
}
