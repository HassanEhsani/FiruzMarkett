// lib/services/products_service.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:typed_data';

class ProductsService {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Map<String, dynamic>>> getProducts() async {
    final res = await supabase
        .from('products')
        .select()
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(res);
  }

  Future<void> deleteProduct(int id) async {
    await supabase.from('products').delete().eq('id', id);
  }

  Future<String> uploadImage(String fileName, Uint8List bytes) async {
    final path = 'products/$fileName.png';

    await supabase.storage
        .from('product-images')
        .uploadBinary(path, bytes, fileOptions: const FileOptions(upsert: false));

    return supabase.storage
        .from('product-images')
        .getPublicUrl(path);
  }

  Future<void> addProduct({
    required String title,
    required double price,
    required int categoryId,
    required String image,
  }) async {
    final payload = {
      'title': title,
      'price': price,
      'category_id': categoryId,
      'image': image,
    };

    await supabase.from('products').insert(payload);
  }
}
