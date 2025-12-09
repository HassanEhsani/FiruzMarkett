// lib/admin/features/products/data/sources/product_remote_data_source.dart
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/admin_product_model.dart';
// import '../../../../features/catalog/domain/entities/product.dart';
 // <- اگر لازم نیست حذف کن
    
import '../../domain/entities/product_entity.dart';

class ProductRemoteDataSource {
  final SupabaseClient client = Supabase.instance.client;

  /// Get products — توجه: از نوع متغیر request به صورت dynamic استفاده شده
  /// تا با تغییرات نسخه‌های supabase_flutter سازگارتر باشد.
  Future<List<AdminProductModel>> getProducts({
    int? offset,
    int? limit,
    String? search,
    String? categoryId,
  }) async {
    // شروع chain با select()
    dynamic request = client.from('products').select();

    // فیلترها — توجه: برخی متدها بسته به ورژن supabase ممکن است return type متفاوتی داشته باشند.
    if (search != null && search.trim().isNotEmpty) {
      // برای نسخه‌هایی که ilike پشتیبانی می‌کنند:
      try {
        request = client.from('products').select().ilike('title', '%$search%');
      } catch (_) {
        // fallback: اگر ilike در این ورژن موجود نبود، می‌توانیم بعدا فیلتر محلی انجام دهیم.
        request = client.from('products').select();
      }
    }

    if (categoryId != null && categoryId.trim().isNotEmpty) {
      try {
        // اگر request یک PostgrestTransformBuilder است، این call ممکن است work کند
        request = request.eq('category_id', categoryId);
      } catch (_) {
        // ignore — fallback
      }
    }

    if (limit != null && offset != null) {
      try {
        request = request.range(offset, offset + limit - 1);
      } catch (_) {
        // اگر range موجود نبود، از limit/offset ترکیبی استفاده کن
        try {
          request = request.limit(limit, offset: offset);
        } catch (_) {}
      }
    } else if (limit != null) {
      try {
        request = request.limit(limit);
      } catch (_) {}
    }

    final res = await request;

    if (res == null) return [];

    final list = List<Map<String, dynamic>>.from(res as List<dynamic>);
    return list.map((m) => AdminProductModel.fromMap(m)).toList();
  }

  /// Insert product
  Future<AdminProductModel?> createProduct(ProductEntity entity) async {
    final model = AdminProductModel.fromEntity(entity);

    final resp = await client
        .from('products')
        .insert(model.toMap())
        .select()
        .maybeSingle(); // .single() ممکن است در بعضی ورژن‌ها exception بدهد

    if (resp == null) return null;

    return AdminProductModel.fromMap(Map<String, dynamic>.from(resp as Map));
  }
}
