// lib/admin/products/widgets/edit_product_dialog.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/services/admin_product_service.dart';
import '../../data/models/admin_product_model.dart';

class EditProductDialog extends StatefulWidget {
  final AdminProductModel product;

  const EditProductDialog({super.key, required this.product});

  @override
  State<EditProductDialog> createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  final AdminProductService service = AdminProductService();

  late TextEditingController titleCtrl;
  late TextEditingController priceCtrl;
  late TextEditingController catCtrl;

  Uint8List? newImageBytes;
  String? pickedName;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    titleCtrl = TextEditingController(text: widget.product.title);
    priceCtrl = TextEditingController(text: widget.product.price.toString());
    catCtrl = TextEditingController(text: widget.product.categoryId);
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    priceCtrl.dispose();
    catCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickNewImage() async {
    final file = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (file != null && file.files.isNotEmpty && file.files.first.bytes != null) {
      setState(() {
        newImageBytes = file.files.first.bytes;
        pickedName = file.files.first.name;
      });
    }
  }

  Future<void> _save() async {
    setState(() => saving = true);

    String finalImageUrl = widget.product.imageUrl;

    // اگر عکس جدید انتخاب شده آپلود کن
    if (newImageBytes != null) {
      final filename = "img_${DateTime.now().millisecondsSinceEpoch}_${pickedName ?? 'img'}.png";
      final newUrl = await service.uploadImageBytes(filename, newImageBytes!);
      if (newUrl.isNotEmpty) finalImageUrl = newUrl;
    }

    // Map برای آپدیت (فقط فیلدهای لازم)
    final data = {
      'title': titleCtrl.text.trim(),
      'price': double.tryParse(priceCtrl.text) ?? 0.0,
      'category_id': catCtrl.text.trim(),
      'image_url': finalImageUrl,
    };

    final ok = await service.updateProduct(widget.product.id, data);

    setState(() => saving = false);
    Navigator.pop(context, ok);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
      content: SizedBox(
        width: 360,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: titleCtrl, decoration: const InputDecoration(label: Text("Title"))),
              const SizedBox(height: 8),
              TextField(controller: priceCtrl, decoration: const InputDecoration(label: Text("Price")), keyboardType: TextInputType.number),
              const SizedBox(height: 8),
              TextField(controller: catCtrl, decoration: const InputDecoration(label: Text("Category ID"))),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _pickNewImage, child: const Text("Select New Image")),
              const SizedBox(height: 8),
              if (newImageBytes != null)
                SizedBox(width: 140, height: 140, child: Image.memory(newImageBytes!, fit: BoxFit.cover))
              else
                (widget.product.imageUrl.isNotEmpty
                    ? SizedBox(width: 140, height: 140, child: Image.network(widget.product.imageUrl, fit: BoxFit.cover))
                    : const SizedBox(width: 140, height: 140, child: Center(child: Text('No image')))),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: saving ? null : _save,
          child: saving ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
        )
      ],
    );
  }
}
