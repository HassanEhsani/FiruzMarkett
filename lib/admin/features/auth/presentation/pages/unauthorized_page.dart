import 'package:flutter/material.dart';

class UnauthorizedPage extends StatelessWidget {
  const UnauthorizedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          "شما اجازه دسترسی به پنل مدیریت را ندارید",
          style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}
