import 'dart:typed_data';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../features/products/data/models/admin_product_model.dart';

class ProductsService {
  final SupabaseClient supabase = Supabase.instance.client;
  final String bucketName = 'product_images';

  Future<List<AdminProductModel>> fetchAllProducts() async {
    final res = await supabase
        .from('products')
        .select()
        .order('created_at', ascending: false);

    final list = List<Map<String, dynamic>>.from(res);
    return list.map((m) => AdminProductModel.fromMap(m)).toList();
  }

  Future<bool> addProduct(AdminProductModel product) async {
    try {
      await supabase.from('products').insert(product.toMap());
      return true;
    } catch (e) {
      print('Add product error: $e');
      return false;
    }
  }

  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      await supabase.from('products').update(data).eq('id', id);
      return true;
    } catch (e) {
      print('Update error: $e');
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      await supabase.from('products').delete().eq('id', id);
      return true;
    } catch (e) {
      print('Delete error: $e');
      return false;
    }
  }

  Future<String> uploadImageBytes(String fileName, Uint8List bytes) async {
    final path = 'products/$fileName';
    try {
      await supabase.storage.from(bucketName).uploadBinary(
            path,
            bytes,
            fileOptions:
                const FileOptions(contentType: 'image/png', upsert: true),
          );

      return supabase.storage.from(bucketName).getPublicUrl(path);
    } catch (e) {
      print('uploadImage error: $e');
      return '';
    }
  }
}
