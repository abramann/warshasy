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

// Dummy widget to launch app faster when entirely rebuild since Attaching is mostly used during development
class DummyApp extends StatelessWidget {
  const DummyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(backgroundColor: Colors.blue, body: Text('Dummy App')),
    );
  }
}
