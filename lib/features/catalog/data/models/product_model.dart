// lib/features/catalog/data/models/product_model.dart
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required String id,
    required Map<String, String> name,
    required Map<String, String> category,
    required int price,
    int? oldPrice,
    required int stock,
    required List<String> gallery,
    required String brand,
    required String sku,
    required double rating,
    required int reviewCount,
    required Map<String, dynamic> attributes,
    required String seller,
    required Map<String, dynamic> deliveryInfo,
    bool isFeatured = false,
    bool isFavorite = false,
  }) : super(
          id: id,
          name: name,
          category: category,
          price: price,
          oldPrice: oldPrice,
          stock: stock,
          gallery: gallery,
          brand: brand,
          sku: sku,
          rating: rating,
          reviewCount: reviewCount,
          attributes: attributes,
          seller: seller,
          deliveryInfo: deliveryInfo,
          isFeatured: isFeatured,
          isFavorite: isFavorite,
        );

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'].toString(),
      name: Map<String, String>.from(map['name'] ?? {}),
      category: Map<String, String>.from(map['category'] ?? {}),
      price: (map['price'] ?? 0) is int ? map['price'] : (map['price'] as num).toInt(),
      oldPrice: map['oldPrice'] != null ? (map['oldPrice'] as num).toInt() : null,
      stock: map['stock'] ?? 0,
      gallery: List<String>.from(map['gallery'] ?? []),
      brand: map['brand'] ?? '',
      sku: map['sku'] ?? '',
      rating: (map['rating'] ?? 0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      attributes: Map<String, dynamic>.from(map['attributes'] ?? {}),
      seller: map['seller'] ?? '',
      deliveryInfo: Map<String, dynamic>.from(map['deliveryInfo'] ?? {}),
      isFeatured: map['isFeatured'] ?? false,
      isFavorite: map['isFavorite'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'oldPrice': oldPrice,
      'stock': stock,
      'gallery': gallery,
      'brand': brand,
      'sku': sku,
      'rating': rating,
      'reviewCount': reviewCount,
      'attributes': attributes,
      'seller': seller,
      'deliveryInfo': deliveryInfo,
      'isFeatured': isFeatured,
      'isFavorite': isFavorite,
    };
  }

  Product toEntity() => this;
}
