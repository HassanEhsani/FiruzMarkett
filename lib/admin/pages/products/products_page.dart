// lib/admin/pages/products/products_page.dart
import 'dart:typed_data';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import '../../features/products/data/models/admin_product_model.dart';
import '../../features/products/data/services/admin_product_service.dart';
import '../../features/products/presentation/widgets/edit_product_dialog.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final AdminProductService service = AdminProductService();

  // pagination / filter / search
  int currentPage = 1;
  int limit = 10;
  String searchText = '';
  String selectedCategory = '';

  List<AdminProductModel> products = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => loading = true);
    final result = await service.fetchProducts(
      page: currentPage,
      limit: limit,
      search: searchText,
      categoryId: selectedCategory.isEmpty ? null : selectedCategory,
    );
    setState(() {
      products = result;
      loading = false;
    });
  }

  Future<void> addProductDialog() async {
    final titleCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final catCtrl = TextEditingController();
    Uint8List? imageBytes;
    String? pickedName;

    await showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(builder: (ctx, setDialogState) {
        return AlertDialog(
          title: Text('add_product'.tr()),
          content: SizedBox(
            width: 360,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleCtrl, decoration: InputDecoration(label: Text('title'.tr()))),
                const SizedBox(height: 8),
                TextField(controller: priceCtrl, decoration: InputDecoration(label: Text('price'.tr())), keyboardType: TextInputType.number),
                const SizedBox(height: 8),
                TextField(controller: catCtrl, decoration: InputDecoration(label: Text('category_id'.tr()))),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () async {
                    final file = await FilePicker.platform.pickFiles(withData: true, type: FileType.image);
                    if (file != null && file.files.isNotEmpty && file.files.first.bytes != null) {
                      imageBytes = file.files.first.bytes;
                      pickedName = file.files.first.name;
                      setDialogState(() {}); // update dialog view
                    }
                  },
                  child: Text('select_image'.tr()),
                ),
                const SizedBox(height: 8),
                if (imageBytes != null) SizedBox(width: 140, height: 140, child: Image.memory(imageBytes!, fit: BoxFit.cover)),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('cancel'.tr())),
            ElevatedButton(
              onPressed: () async {
                if (titleCtrl.text.trim().isEmpty || imageBytes == null) return;

                final fileName = "img_${DateTime.now().millisecondsSinceEpoch}_${pickedName ?? 'img'}.png";
                final imageUrl = await service.uploadImageBytes(fileName, imageBytes!);

                final model = AdminProductModel(
                  id: '',
                  title: titleCtrl.text.trim(),
                  description: '',
                  price: double.tryParse(priceCtrl.text) ?? 0.0,
                  categoryId: catCtrl.text.trim(),
                  imageUrl: imageUrl,
                  createdAt: DateTime.now(),
                );

                final ok = await service.addProduct(model);
                if (!ok) {
                  if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('add_failed'.tr())));
                  return;
                }

                if (mounted) Navigator.pop(ctx);
                await loadProducts();
              },
              child: Text('save'.tr()),
            ),
          ],
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return const Center(child: CircularProgressIndicator());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('products'.tr(), style: const TextStyle(fontSize: 20)),
              ElevatedButton(onPressed: addProductDialog, child: Text('add_product'.tr())),
            ],
          ),
          const SizedBox(height: 12),

          // search + filter
          Row(
            children: [
              Expanded(
                child: TextField(
                  decoration: InputDecoration(prefixIcon: const Icon(Icons.search), hintText: 'search'.tr()),
                  onChanged: (val) {
                    searchText = val;
                    currentPage = 1;
                    loadProducts();
                  },
                ),
              ),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: selectedCategory.isEmpty ? null : selectedCategory,
                hint: Text('category'.tr()),
                items: [
                  DropdownMenuItem(value: "", child: Text('all'.tr())),
                  DropdownMenuItem(value: "1", child: Text('category_mobile'.tr())),
                  DropdownMenuItem(value: "2", child: Text('category_laptop'.tr())),
                  DropdownMenuItem(value: "3", child: Text('category_watch'.tr())),
                ],
                onChanged: (v) {
                  selectedCategory = v ?? '';
                  currentPage = 1;
                  loadProducts();
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          // table
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: [
                  DataColumn(label: Text('id'.tr())),
                  DataColumn(label: Text('image'.tr())),
                  DataColumn(label: Text('title'.tr())),
                  DataColumn(label: Text('price'.tr())),
                  DataColumn(label: Text('category_id'.tr())),
                  DataColumn(label: Text('actions'.tr())),
                ],
                rows: products.map((p) {
                  return DataRow(cells: [
                    DataCell(Text(p.id)),
                    DataCell(p.imageUrl.isNotEmpty
                        ? SizedBox(width: 56, height: 56, child: Image.network(p.imageUrl, fit: BoxFit.cover, errorBuilder: (c,e,s)=>const Icon(Icons.broken_image)))
                        : const Icon(Icons.image_not_supported)),
                    DataCell(Text(p.title)),
                    DataCell(Text(p.price.toString())),
                    DataCell(Text(p.categoryId)),
                    DataCell(Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final updated = await showDialog(context: context, builder: (_) => EditProductDialog(product: p));
                            if (updated == true) await loadProducts();
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () async {
                            final ok = await service.deleteProduct(p.id);
                            if (!ok) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('delete_failed'.tr())));
                            }
                            await loadProducts();
                          },
                        ),
                      ],
                    )),
                  ]);
                }).toList(),
              ),
            ),
          ),

          // pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                onPressed: currentPage > 1
                    ? () {
                        setState(() => currentPage--);
                        loadProducts();
                      }
                    : null,
                child: Text('prev'.tr()),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Text('${'page'.tr()} $currentPage'),
              ),
              TextButton(
                onPressed: () {
                  setState(() => currentPage++);
                  loadProducts();
                },
                child: Text('next'.tr()),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
