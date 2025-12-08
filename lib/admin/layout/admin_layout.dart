// lib/admin/layout/admin_layout.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // هر تغییری در locale این متد را ری‌بیلد می‌کند
    final locale = context.locale;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          'dashboard_title'.tr(),
          style: const TextStyle(color: Colors.black87),
        ),
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Locale>(
                value: locale,
                items: const [
                  DropdownMenuItem(value: Locale('fa'), child: Text('FA')),
                  DropdownMenuItem(value: Locale('en'), child: Text('EN')),
                  DropdownMenuItem(value: Locale('ru'), child: Text('RU')),
                ],
                onChanged: (selected) {
                  if (selected != null) {
                    context.setLocale(selected); // باعث ری‌بیلد کل UI می‌شود
                  }
                },
              ),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          AdminSidebar(), // بدون const
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.grey.shade100,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
