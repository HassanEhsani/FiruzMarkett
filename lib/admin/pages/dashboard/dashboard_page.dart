import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    // صفحه داشبورد بسیار ساده تا بعدا کارت‌ها و نمودار اضافه شوند
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'dashboard'.tr(), // از translations استفاده می‌کند
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Welcome to Admin Dashboard',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ],
      ),
    );
  }
}
