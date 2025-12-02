import 'package:flutter/material.dart';
import 'package:warshasy/core/env/supabase.dart';
import 'warshasy.dart';
import 'core/utils/injection_container.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseConfig.initialize();
  await di.init();

  runApp(const Warshasy());
}
