// lib/features/catalog/data/models/product_model.dart
import '../../domain/entities/product.dart';

class ProductModel extends Product {
  ProductModel({
    required super.id,
    required super.name,
    required super.category,
    required super.price,
    super.oldPrice,
    required super.stock,
    required super.gallery,
    required super.brand,
    required super.sku,
    required super.image,
    required super.rating,
    required super.reviewCount,
    required super.attributes,
    required super.seller,
    required super.deliveryInfo,
    super.isFeatured,
    super.isFavorite = false,
  });

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
      image: map['image'] ?? '',

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
      'image': image,
    };
  }

  Product toEntity() => this;
}
