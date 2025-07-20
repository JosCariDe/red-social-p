import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/di/injection.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/posts_list_view.dart';
import 'package:red_social_prueba/features/post/presentation/posts_user/blocs/user_posts_bloc/user_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/posts_user/widgets/user_posts_list_view.dart';
import 'package:red_social_prueba/features/user/presentation/login/blocs/auth_user_bloc/auth_user_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';

class UserPostsScreen extends StatelessWidget {
  const UserPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthUserBloc, AuthUserState>(
      builder: (context, authState) {
        //? Como es local el user, no va aparecer este screen, pero bueno para probar en un futuro.
        if (authState is! AuthUserAuthenticated) {
          return const Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.person_off, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('No autenticado'),
                  Text('Por favor inicia sesión'),
                ],
              ),
            ),
          );
        }
        
        final userId = authState.user.id;

        return BlocProvider(
          create: (_) => sl<UserPostsBloc>()..add(GetUserPosts(userId: userId)),
          child: BlocListener<UpdatedReactionsPostBloc, UpdatedReactionsPostState>(
            listener: (context, state) {
              if (state is UpdatedReactionsPostSuccess) {
                context.read<UserPostsBloc>().add(ReloadUserPosts(userId: userId));
              }
            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Mis publicaciones'),
                actions: [
                  BlocBuilder<UserPostsBloc, UserPostsState>(
                    builder: (context, state) {
                      return IconButton(
                        icon: state is UserPostsLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.refresh),
                        onPressed: state is UserPostsLoading
                            ? null
                            : () {
                                context.read<UserPostsBloc>().add(
                                      ReloadUserPosts(userId: userId),
                                    );
                              },
                        tooltip: 'Actualizar publicaciones',
                      );
                    },
                  ),
                ],
              ),
              body: UserPostsListView(
                userId: userId,
                onPostTap: (post) {
                  debugPrint('Post seleccionado: ${post.id}');
                },
              ),
              
            ),
          ),
        );
      },
    );
  }
}
