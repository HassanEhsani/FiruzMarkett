import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<bool> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;

      if (user == null) return false;

      // گرفتن role از جدول metadata یا user.public
      final role = user.userMetadata?['role'];

      return role == 'admin';
    } catch (e) {
      return false;
    }
  }
}
