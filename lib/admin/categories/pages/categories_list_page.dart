import 'package:flutter/material.dart';

class CategoriesListPage extends StatelessWidget {
  const CategoriesListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Categories"),
      ),
      body: const Center(
        child: Text("Categories List Page"),
      ),
    );
  }
}
