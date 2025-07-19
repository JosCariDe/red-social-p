
import 'package:go_router/go_router.dart';

import '../../features/post/presentation/views_post_exports.dart'; //Exportacion de barril
import '../../features/user/presentation/views_user_exports.dart'; //Exportacion de barril

final appRouter = GoRouter(
  routes: [

    GoRoute(
      path: '/',
      builder: (context, state) => const HomeView(),
    ),

    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginView(),
    )

  ]
);