// lib/features/catalog/domain/entities/product.dart
class Product {
  final String id;
  final Map<String, String> name;     // {ru: "", en: "", fa: ""}
  final Map<String, String> category; // {ru: "", en: "", fa: ""}
  final int price;
  final int? oldPrice;
  final int stock;
  final List<String> gallery;
  final String brand;
  final String sku;
  final double rating;
  final int reviewCount;
  final Map<String, dynamic> attributes;
  final String seller;
  final Map<String, dynamic> deliveryInfo;
  final bool isFeatured;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.stock,
    required this.gallery,
    required this.brand,
    required this.sku,
    required this.rating,
    required this.reviewCount,
    required this.attributes,
    required this.seller,
    required this.deliveryInfo,
    this.isFeatured = false,
    this.isFavorite = false,
  });

  String nameByLanguage(String lang) => name[lang] ?? name['ru'] ?? '';

  String categoryByLanguage(String lang) => category[lang] ?? category['ru'] ?? '';

  String get formattedPrice => '$price ₽';

  String? get formattedOldPrice => oldPrice != null ? '$oldPrice ₽' : null;

  int? get discountPercent {
    if (oldPrice != null && oldPrice! > price) {
      return ((oldPrice! - price) / oldPrice! * 100).round();
    }
    return null;
  }
}
