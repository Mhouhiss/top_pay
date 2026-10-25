import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:top_pay/core/providers/theme_provider.dart';
import 'package:top_pay/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:top_pay/core/router/app_routes.dart';
import 'package:top_pay/core/theme/app_theme.dart';
import 'package:top_pay/core/providers/storage_service_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: TopPayApp(),
    ),
  );
}

class TopPayApp extends ConsumerWidget {
  const TopPayApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp.router(
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      title: 'TopPay',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
    );
  }
}
