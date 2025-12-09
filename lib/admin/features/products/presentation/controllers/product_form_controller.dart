// lib/admin/features/products/presentation/controllers/product_form_controller.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../../data/models/admin_product_model.dart';
import '../../data/services/admin_product_service.dart';

class ProductFormController extends ChangeNotifier {
  final AdminProductService service = AdminProductService();

  bool loading = false;
  Uint8List? pickedImageBytes;
  String? pickedImageName;

  void setImage(Uint8List bytes, String name) {
    pickedImageBytes = bytes;
    pickedImageName = name;
    notifyListeners();
  }

  void clearImage() {
    pickedImageBytes = null;
    pickedImageName = null;
    notifyListeners();
  }

  Future<String> uploadImageIfExists() async {
    if (pickedImageBytes == null) return '';
    final fileName = 'img_${DateTime.now().millisecondsSinceEpoch}_${pickedImageName ?? 'img'}.png';
    final url = await service.uploadImageBytes(fileName, pickedImageBytes!);
    return url;
  }

  /// existing: مدل فعلی (برای ویرایش)، model: اطلاعات از فرم (title, price, ...)
  Future<bool> saveProduct({AdminProductModel? existing, required AdminProductModel model}) async {
    loading = true;
    notifyListeners();

    try {
      String imageUrl = model.imageUrl;
      if (pickedImageBytes != null) {
        final uploaded = await uploadImageIfExists();
        if (uploaded.isNotEmpty) imageUrl = uploaded;
      }

      final finalModel = AdminProductModel(
        id: existing?.id ?? '',
        title: model.title,
        description: model.description,
        price: model.price,
        categoryId: model.categoryId,
        imageUrl: imageUrl,
        createdAt: existing?.createdAt ?? DateTime.now(),
      );

      bool ok;
      if (existing == null || existing.id.isEmpty) {
        ok = await service.addProduct(finalModel);
      } else {
        // updateProduct در سرویس انتظار map دارد: پس ضمناً toMap فرستاده می‌شود
        ok = await service.updateProduct(existing.id, finalModel.toMap());
      }

      loading = false;
      notifyListeners();
      return ok;
    } catch (e) {
      debugPrint('saveProduct error: $e');
      loading = false;
      notifyListeners();
      return false;
    }
  }
}
