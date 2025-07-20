import 'package:flutter/material.dart';
import 'package:red_social_prueba/config/router/app_router.dart';
import 'package:red_social_prueba/config/theme/app_theme.dart';
import 'package:red_social_prueba/di/injection.dart' as di;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
    );
  }
}
