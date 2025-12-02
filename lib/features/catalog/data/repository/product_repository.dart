// lib/features/catalog/data/repository/product_repository.dart
import '../../domain/entities/product.dart';

abstract class ProductRepository {
  Future<Product> getProductById(String id);
  Future<List<Product>> getProducts({int page = 1, int limit = 20, Map<String, dynamic>? filters});
  Future<void> addProduct(Product product);
  Future<void> updateProduct(Product product);
  Future<void> deleteProduct(String id);
}
