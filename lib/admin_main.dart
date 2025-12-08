// lib/admin_main.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:firuz_market/admin/banners/pages/banners_list_page.dart';
import 'package:firuz_market/admin/categories/pages/categories_list_page.dart';
import 'package:firuz_market/admin/dashboard/pages/admin_dashboard_page.dart';
import 'package:firuz_market/admin/dashboard/pages/admin_dashboard_screen.dart';
import 'package:firuz_market/admin/layout/admin_layout.dart';
import 'package:firuz_market/admin/pages/products/products_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


import 'admin/auth/pages/admin_login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Supabase.initialize(
    url: 'https://zeojgniocjypnfgneiqb.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inplb2pnbmlvY2p5cG5mZ25laXFiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NDA1NjQsImV4cCI6MjA4MDMxNjU2NH0.qlmeQZRhn9V8LVo8DH54e9Ov3r2MYeE2IErS1RG1pEI',
  );

  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en'),
        Locale('fa'),
        Locale('ru'),
      ],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const AdminApp(),
    ),
  );
}

/// utility برای چک کردن نقش ادمین (در صورت استفاده)
Future<bool> isAdmin() async {
  final user = Supabase.instance.client.auth.currentUser;
  if (user == null) return false;
  final role = (user.userMetadata ?? {})['role'];
  return role == "admin";
}

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('access_denied'.tr())), // add key access_denied در ترجمه
    );
  }
}

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin - Firuz Market',
      debugShowCheckedModeBanner: false,
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      initialRoute: '/admin/login',
      routes: {
        '/admin/login': (context) => const AdminLoginPage(),
        '/admin/dashboard': (context) =>
    const AdminLayout(child: AdminDashboardPage()),


        '/admin/products': (context) => const AdminLayout(child: ProductsPage()),
        '/admin/categories': (context) =>
            const AdminLayout(child: CategoriesListPage()),
        '/admin/banners': (context) =>
            const AdminLayout(child: BannersListPage()),
      },
    );
  }
}















// await Supabase.initialize(
//     url: 'https://zeojgniocjypnfgneiqb.supabase.co',
//     anonKey:
//         'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inplb2pnbmlvY2p5cG5mZ25laXFiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQ3NDA1NjQsImV4cCI6MjA4MDMxNjU2NH0.qlmeQZRhn9V8LVo8DH54e9Ov3r2MYeE2IErS1RG1pEI', // کلیدت را اینجا قرار بده (مراقب باش عمومی نشه)
//   );
