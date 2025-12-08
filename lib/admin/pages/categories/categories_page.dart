import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('categories'.tr(), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Center(child: Text('Categories management coming soon')),
      ],
    );
  }
}
