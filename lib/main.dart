import 'package:flutter/material.dart';
import 'package:warshasy/core/config/supabase_config.dart';
import 'warshasy.dart';
import 'core/config/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  await di.init();

  runApp(const Warshasy());
}
