import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static const String supabaseUrl = 'https://ckgiabavftlylckmgyvf.supabase.co';
  static const String supabaseAnonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNrZ2lhYmF2ZnRseWxja21neXZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjE1NjYwMzAsImV4cCI6MjA3NzE0MjAzMH0.ybHlcfjSnf-q1SESz10_aZnbXStuktKaqgwGlmQpikQ';
  static Future<void> initialize() async {
    await Supabase.initialize(url: supabaseUrl, anonKey: supabaseAnonKey);
  }

  static SupabaseClient get client => Supabase.instance.client;
}
