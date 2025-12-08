import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final supabase = Supabase.instance.client;

  Future<String?> login(String email, String password) async {
    try {
      final response = await supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) return null;

      // خواندن نقش کاربر
      final roleData = await supabase
          .from('user_roles')
          .select('role')
          .eq('user_id', user.id)
          .maybeSingle();

      final role = roleData?['role'] as String?;

      return role;
    } catch (e) {
      print("LOGIN ERROR: $e");
      return null;
    }
  }
}




// 11a8e316-402a-4d92-aaa5-0161a062eb55 user auth- admin-firuz