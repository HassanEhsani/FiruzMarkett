// lib/services/supabase/supabase_service.dart
// دقت: مقادیر URL و KEY را از .env یا محیط CI/CD بارگذاری کن — هیچوقت مستقیم داخل کد نذار
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient? _client;

  static void init({required String url, required String anonKey}) {
    if (_client == null) {
      _client = SupabaseClient(url, anonKey);
    }
  }

  static SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized. Call SupabaseService.init(...) first.');
    }
    return _client!;
  }
}
