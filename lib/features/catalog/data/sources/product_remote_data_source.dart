// lib/features/catalog/data/sources/product_remote_data_source.dart
import '../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<ProductModel> fetchProduct(String id);
  Future<List<ProductModel>> fetchProducts({int page = 1, int limit = 20, Map<String, dynamic>? filters});
  Future<void> createProduct(ProductModel product);
  Future<void> updateProduct(ProductModel product);
  Future<void> deleteProduct(String id);
}
