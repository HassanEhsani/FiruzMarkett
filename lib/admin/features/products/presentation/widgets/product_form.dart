// lib/admin/products/widgets/product_form.dart
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../data/models/admin_product_model.dart';
import '../../data/services/admin_product_service.dart';

class ProductForm extends StatefulWidget {
  final AdminProductModel? existing;
  final void Function(AdminProductModel model) onSaved;

  const ProductForm({super.key, this.existing, required this.onSaved});

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _desc = TextEditingController();
  final _category = TextEditingController();

  Uint8List? pickedImage;
  String? pickedName;
  bool loading = false;

  final AdminProductService service = AdminProductService();

  @override
  void initState() {
    super.initState();
    if (widget.existing != null) {
      _title.text = widget.existing!.title;
      _price.text = widget.existing!.price.toString();
      _desc.text = widget.existing!.description;
      _category.text = widget.existing!.categoryId;
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _desc.dispose();
    _category.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final res = await FilePicker.platform.pickFiles(type: FileType.image, withData: true);
    if (res != null && res.files.isNotEmpty && res.files.first.bytes != null) {
      setState(() {
        pickedImage = res.files.first.bytes;
        pickedName = res.files.first.name;
      });
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => loading = true);

    String imageUrl = widget.existing?.imageUrl ?? '';

    if (pickedImage != null) {
      final filename = "img_${DateTime.now().millisecondsSinceEpoch}_${pickedName ?? 'img'}.png";
      final url = await service.uploadImageBytes(filename, pickedImage!);
      if (url.isNotEmpty) imageUrl = url;
    }

    final model = AdminProductModel(
      id: widget.existing?.id ?? '',
      title: _title.text.trim(),
      description: _desc.text.trim(),
      price: double.tryParse(_price.text.trim()) ?? 0.0,
      categoryId: _category.text.trim(),
      imageUrl: imageUrl,
      createdAt: widget.existing?.createdAt ?? DateTime.now(),
    );

    bool ok;
    if (widget.existing == null) {
      ok = await service.addProduct(model);
    } else {
      ok = await service.updateProduct(model.id, model.toMap());
    }

    setState(() => loading = false);

    if (ok) {
      widget.onSaved(model);
    } else {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Save failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(controller: _title, decoration: const InputDecoration(labelText: 'Title'), validator: (v) => (v==null||v.trim().isEmpty)?'Required':null),
          const SizedBox(height: 8),
          TextFormField(controller: _price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          const SizedBox(height: 8),
          TextFormField(controller: _category, decoration: const InputDecoration(labelText: 'Category ID')),
          const SizedBox(height: 8),
          TextFormField(controller: _desc, decoration: const InputDecoration(labelText: 'Description'), maxLines: 3),
          const SizedBox(height: 12),
          Row(
            children: [
              ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image), label: const Text('Select Image')),
              const SizedBox(width: 12),
              if (pickedImage != null)
                SizedBox(width: 80, height: 80, child: Image.memory(pickedImage!, fit: BoxFit.cover))
              else if (widget.existing?.imageUrl != null && widget.existing!.imageUrl.isNotEmpty)
                SizedBox(width: 80, height: 80, child: Image.network(widget.existing!.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s)=>const Icon(Icons.broken_image)))
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(onPressed: loading ? null : _save, child: loading ? const SizedBox(width: 18,height:18,child:CircularProgressIndicator(strokeWidth:2)) : const Text('Save')),
              const SizedBox(width: 12),
              TextButton(onPressed: () => Navigator.of(context).maybePop(), child: const Text('Cancel')),
            ],
          )
        ],
      ),
    );
  }
}
