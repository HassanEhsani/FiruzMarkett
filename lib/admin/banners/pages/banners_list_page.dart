import 'package:flutter/material.dart';

class BannersListPage extends StatelessWidget {
  const BannersListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Banners"),
      ),
      body: const Center(
        child: Text("Banners List Page"),
      ),
    );
  }
}
