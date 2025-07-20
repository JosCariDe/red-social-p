import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/config/exports/exports_data.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';
import 'package:red_social_prueba/features/user/presentation/login/blocs/login_bloc/login_bloc.dart';
import '../../features/post/presentation/views_post_exports.dart';
import '../../features/user/presentation/views_user_exports.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/post_detail/blocs/get_one_post_by_id/get_post_by_id_bloc.dart';
import 'package:red_social_prueba/di/injection.dart';

final appRouter = GoRouter(
  //initialLocation: '/posts',
  initialLocation: '/login',
  routes: [
    GoRoute(
      path: '/posts',
      builder: (context, state) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => sl<GetAllPostsBloc>()),
          BlocProvider(create: (_) => sl<UpdatedReactionsPostBloc>()),
        ],
        child: const HomeScreen(),
      ),
    ),
    GoRoute(
      path: '/posts/:id',
      builder: (context, state) {
        final postId = int.parse(state.pathParameters['id']!);
        return MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) =>
                  sl<GetPostByIdBloc>()..add(GetPostById(idPost: postId)),
            ),
            BlocProvider(create: (_) => sl<UpdatedReactionsPostBloc>()),
          ],
          child: PostDetailScreen(idPost: postId),
        );
      },
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) {
        return BlocProvider(
          create: (_) => sl<LoginBloc>(),
          child: LoginScreen(),
        );
      },
    ),

    GoRoute(
  path: '/create-post',
  builder: (context, state) => BlocProvider(
    create: (_) => sl<CreatePostBloc>(),
    child: const CreatePostScreen(),
  ),
),
  ],
);
