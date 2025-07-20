import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/di/injection.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/posts_list_view.dart';
import 'package:red_social_prueba/features/post/presentation/posts_user/blocs/user_posts_bloc/user_posts_bloc.dart';
import 'package:red_social_prueba/features/user/presentation/login/blocs/auth_user_bloc/auth_user_bloc.dart';

class UserPostsScreen extends StatelessWidget {
  const UserPostsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthUserBloc>().state;
    if (authState is! AuthUserAuthenticated) {
      return const Scaffold(body: Center(child: Text('No autenticado')));
    }
    final userId = authState.user.id;

    return BlocProvider(
      create: (_) => sl<UserPostsBloc>()..add(GetUserPosts(userId: userId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Mis publicaciones')),
        body: BlocBuilder<UserPostsBloc, UserPostsState>(
          builder: (context, state) {
            if (state is UserPostsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is UserPostsError) {
              return Center(child: Text(state.message));
            }
            if (state is UserPostsSuccess) {
              return PostsListView(
                posts: state.posts,
                onPostTap: (post) => context.push('/posts/${post.id}'),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}