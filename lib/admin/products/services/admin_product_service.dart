import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../models/admin_product_model.dart';

class AdminProductService {
  final SupabaseClient supabase = Supabase.instance.client;
  final String bucket = 'product_images';

  // ---------------------------------------------------------
  // 📌 1) FETCH PRODUCTS WITH FILTER + SEARCH + PAGINATION
  // ---------------------------------------------------------
  Future<List<AdminProductModel>> fetchProducts({
    required int page,
    required int limit,
    String? search,
    String? categoryId,
  }) async {
    final int from = (page - 1) * limit;
    final int to = from + limit - 1;

    try {
      PostgrestFilterBuilder query =
          supabase.from('products').select('*'); // MUST HAVE!

      // 🔍 Search
      if (search != null && search.trim().isNotEmpty) {
        query = query.ilike('title', '%$search%');
      }

      // 🏷 Filter
      if (categoryId != null && categoryId.isNotEmpty) {
        query = query.eq('category_id', categoryId);
      }

      // 📌 Pagination + Sorting
      final data = await query
          .order('created_at', ascending: false)
          .range(from, to);

      if (data == null) return [];

      final list = List<Map<String, dynamic>>.from(data);
      return list.map((e) => AdminProductModel.fromMap(e)).toList();
    } catch (e) {
      debugPrint("fetchProducts exception: $e");
      return [];
    }
  }

  // ---------------------------------------------------------
  // 📌 2) ADD PRODUCT
  // ---------------------------------------------------------
  Future<bool> addProduct(AdminProductModel model) async {
    try {
      await supabase
          .from('products')
          .insert(model.toMap())
          .select(); // required for v2

      return true;
    } catch (e) {
      debugPrint("addProduct exception: $e");
      return false;
    }
  }

  // ---------------------------------------------------------
  // 📌 3) DELETE PRODUCT
  // ---------------------------------------------------------
  Future<bool> deleteProduct(String id) async {
    try {
      await supabase
          .from('products')
          .delete()
          .eq('id', id);

      return true;
    } catch (e) {
      debugPrint("deleteProduct exception: $e");
      return false;
    }
  }

  // ---------------------------------------------------------
  // 📌 4) UPDATE PRODUCT
  // ---------------------------------------------------------
  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      await supabase
          .from('products')
          .update(data)
          .eq('id', id)
          .select(); // required

      return true;
    } catch (e) {
      debugPrint("updateProduct exception: $e");
      return false;
    }
  }

  // ---------------------------------------------------------
  // 📌 5) UPLOAD IMAGE
  // ---------------------------------------------------------
  Future<String> uploadImageBytes(String fileName, Uint8List bytes) async {
    try {
      final path = 'products/$fileName';

      await supabase.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );

      return supabase.storage.from(bucket).getPublicUrl(path);
    } catch (e) {
      debugPrint("uploadImageBytes exception: $e");
      return '';
    }
  }
}
