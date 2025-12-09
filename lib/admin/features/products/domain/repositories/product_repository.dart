import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts({
    int? page,
    int? limit,
    String? search,
    String? categoryId,
  });

  Future<ProductEntity?> createProduct(ProductEntity product);

  Future<void> updateProduct(ProductEntity product);

  Future<void> deleteProduct(String id);
}
