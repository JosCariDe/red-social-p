import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/config/router/app_router.dart';
import 'package:red_social_prueba/config/theme/app_theme.dart';
import 'package:red_social_prueba/di/injection.dart' as di;
import 'package:red_social_prueba/features/user/presentation/login/blocs/auth_user_bloc/auth_user_bloc.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(
    BlocProvider(
      //? Bloc Global para tener siempre el user em todo el arbol de widgets.
      create: (_) => di.sl<AuthUserBloc>(),
      child: const MainApp(),
    ),
  );
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
