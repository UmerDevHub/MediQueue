import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/config.dart';
import 'core/router.dart';
import 'core/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseAnonKey,
  );
  runApp(
    const ProviderScope(
      child: MediQueueApp(),
    ),
  );
}

class MediQueueApp extends StatelessWidget {
  const MediQueueApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'MediQueue',
      theme: buildTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}

