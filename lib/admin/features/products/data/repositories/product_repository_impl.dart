import '../../domain/repositories/product_repository.dart';
import '../../domain/entities/product_entity.dart';
import '../sources/product_remote_data_source.dart';
// import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remote;

  ProductRepositoryImpl(this.remote);

  @override
  Future<List<ProductEntity>> getProducts({
    int? page,
    int? limit,
    String? search,
    String? categoryId,
  }) async {
    final offset = (page != null && limit != null) ? (page - 1) * limit : null;

    final models = await remote.getProducts(
      offset: offset,
      limit: limit,
      search: search,
      categoryId: categoryId,
    );

    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<ProductEntity?> createProduct(ProductEntity product) async {
    final created = await remote.createProduct(product);
    return created?.toEntity();
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    // TODO: implement update via remote (update query)
    throw UnimplementedError();
  }

  @override
  Future<void> deleteProduct(String id) async {
    // TODO: implement delete via remote (delete query)
    throw UnimplementedError();
  }
}
