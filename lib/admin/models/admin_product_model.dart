// lib/admin/models/admin_product_model.dart
class AdminProductModel {
  final String id;
  final String title;
  final String description;
  final double price;
  final String categoryId;
  final String imageUrl;
  final DateTime createdAt;

  AdminProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.categoryId,
    required this.imageUrl,
    required this.createdAt,
  });

  /// ساخت از Map برگشتی از Supabase
  factory AdminProductModel.fromMap(Map<String, dynamic> map) {
    return AdminProductModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] as num?)?.toDouble() ?? 0.0,
      // توجه: در دیتابیس شما ستون ممکن است 'category_id' یا 'categori_id' باشد.
      // اگر نام ستون فرق کند همینجا اصلاح کن.
      categoryId: map['category_id']?.toString() ?? map['categori_id']?.toString() ?? '',
      // نام ستون عکس در DB: image_url یا image (مطابقت بده)
      imageUrl: map['image_url']?.toString() ?? map['image']?.toString() ?? '',
      createdAt: _parseDate(map['created_at']),
    );
  }

  static DateTime _parseDate(dynamic v) {
    if (v == null) return DateTime.now();
    if (v is DateTime) return v;
    try {
      return DateTime.parse(v.toString());
    } catch (_) {
      return DateTime.now();
    }
  }

  /// تبدیل به Map برای insert/update
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'image_url': imageUrl,
      // معمولاً created_at را سرور ست می‌کند؛ اگر خواستی ارسالش کن.
    };
  }
}
