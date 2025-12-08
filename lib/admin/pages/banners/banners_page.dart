import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class BannersPage extends StatelessWidget {
  const BannersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('ads'.tr(), style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Center(child: Text('Banners / Promotions management coming soon')),
      ],
    );
  }
}
