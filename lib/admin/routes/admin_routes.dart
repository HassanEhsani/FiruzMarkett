import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';
import '../pages/dashboard/dashboard_page.dart';
import '../pages/products/products_page.dart';
import '../pages/categories/categories_page.dart';
import '../pages/banners/banners_page.dart';
import '../products/pages/add_edit_product_page.dart';

class AdminRoutes {
  static Map<String, WidgetBuilder> routes = {
    '/admin/dashboard': (_) =>
        const AdminLayout(child: DashboardPage()),
    '/admin/products': (_) =>
        const AdminLayout(child: ProductsPage()),
    '/admin/products/add': (_) =>
        const AdminLayout(child: AddEditProductPage()),
    '/admin/categories': (_) =>
        const AdminLayout(child: CategoriesPage()),
    '/admin/banners': (_) =>
        const AdminLayout(child: BannersPage()),
  };

  static goDashboard(BuildContext context) =>
      Navigator.pushReplacementNamed(context, '/admin/dashboard');

  static goProducts(BuildContext context) =>
      Navigator.pushReplacementNamed(context, '/admin/products');

  static goCategories(BuildContext context) =>
      Navigator.pushReplacementNamed(context, '/admin/categories');

  static goBanners(BuildContext context) =>
      Navigator.pushReplacementNamed(context, '/admin/banners');
}
