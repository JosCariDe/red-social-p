import 'package:go_router/go_router.dart';

import '../../features/post/presentation/views_post_exports.dart'; //Exportacion de barril
import '../../features/user/presentation/views_user_exports.dart'; //Exportacion de barril

final appRouter = GoRouter(
  initialLocation: '/posts',
  routes: [
    GoRoute(path: '/posts', builder: (context, state) => const HomeScreen()),

    GoRoute(
      path: '/posts/:id',
      builder: (context, state) {
        final postId = int.parse(state.pathParameters['id']!);
        return PostDetailScreen(idPost: postId);
      },
    ),

    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
  ],
);
