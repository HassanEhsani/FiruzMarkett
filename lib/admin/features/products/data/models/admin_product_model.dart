// lib/admin/features/products/data/models/admin_product_model.dart
import '../../domain/entities/product_entity.dart';

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

  factory AdminProductModel.fromMap(Map<String, dynamic> map) {
    return AdminProductModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString() ?? '',
      price: (map['price'] is int)
          ? (map['price'] as int).toDouble()
          : (map['price'] as num?)?.toDouble() ?? 0.0,
      categoryId: map['category_id']?.toString() ?? '',
      imageUrl: map['image_url']?.toString() ?? map['image']?.toString() ?? '',
      createdAt: _parseDate(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      if (id.isNotEmpty) 'id': id,
      'title': title,
      'description': description,
      'price': price,
      'category_id': categoryId,
      'image_url': imageUrl,
      // created_at: usually set by DB timestamps, don't send unless needed
    };
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

  /// تبدیل به ProductEntity (لایه دامِین)
  ProductEntity toEntity() {
    return ProductEntity(
      id: id,
      name: title, // mapping explicit: title -> name in entity
      description: description,
      price: price,
      imageUrl: imageUrl,
      categoryId: categoryId,
    );
  }

  /// ساخت از ProductEntity
  factory AdminProductModel.fromEntity(ProductEntity e) {
    return AdminProductModel(
      id: e.id,
      title: e.name, // entity.name -> model.title
      description: e.description,
      price: e.price,
      categoryId: e.categoryId,
      imageUrl: e.imageUrl,
      createdAt: DateTime.now(),
    );
  }
}
