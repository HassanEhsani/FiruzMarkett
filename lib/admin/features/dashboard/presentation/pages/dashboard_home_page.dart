import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class DashboardHomePage extends StatelessWidget {
  const DashboardHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("dashboard".tr()),
        actions: [
          // دکمه تغییر زبان
          PopupMenuButton(
            onSelected: (value) {
              context.setLocale(Locale(value));
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'fa',
                child: Text("فارسی"),
              ),
              const PopupMenuItem(
                value: 'en',
                child: Text("English"),
              ),
              const PopupMenuItem(
                value: 'ru',
                child: Text("Русский"),
              ),
            ],
          ),
        ],
      ),
      body: Center(
        child: Text(
          "dashboard".tr(),
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
