// lib/admin/widgets/admin_sidebar.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:firuz_market/admin/routes/admin_routes.dart';
import 'package:flutter/material.dart';
// import '../routes/admin_routes.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          // عنوان پنل — از ترجمه استفاده شده
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'dashboard_title'.tr(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),

          // آیتم‌های منو — همه با کلید ترجمه
          SidebarItem(
            titleKey: 'dashboard',
            onTap: () => AdminRoutes.goDashboard(context),
          ),
          SidebarItem(
            titleKey: 'products',
            onTap: () => AdminRoutes.goProducts(context),
          ),
          SidebarItem(
            titleKey: 'categories',
            onTap: () => AdminRoutes.goCategories(context),
          ),
          SidebarItem(
            titleKey: 'banners',
            onTap: () => AdminRoutes.goBanners(context),
          ),
        ],
      ),
    );
  }
}

class SidebarItem extends StatelessWidget {
  final String titleKey;
  final VoidCallback onTap;
  const SidebarItem({
    super.key,
    required this.titleKey,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Text(
          titleKey.tr(),
          style: const TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
