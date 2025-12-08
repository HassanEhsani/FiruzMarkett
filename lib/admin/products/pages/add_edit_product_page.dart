// lib/admin/products/pages/add_edit_product_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../../models/admin_product_model.dart';
import '../widgets/product_form.dart';

class AddEditProductPage extends StatelessWidget {
  final AdminProductModel? existing;
  const AddEditProductPage({super.key, this.existing});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(existing == null ? 'add_product'.tr() : 'edit_product'.tr()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ProductForm(
          existing: existing,
          onSaved: (model) {
            // بعد از سیو موفق، برگرد به لیست و ری‌فرش کن
            Navigator.of(context).pop(true);
          },
        ),
      ),
    );
  }
}
