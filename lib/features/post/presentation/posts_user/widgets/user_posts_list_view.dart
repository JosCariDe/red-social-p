import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/post_card.dart';
import 'package:red_social_prueba/features/post/presentation/posts_user/blocs/user_posts_bloc/user_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';

class UserPostsListView extends StatefulWidget {
  final int userId;
  final Function(dynamic)? onPostTap;
  
  const UserPostsListView({
    super.key,
    required this.userId,
    this.onPostTap,
  });

  @override
  State<UserPostsListView> createState() => _UserPostsListViewState();
}

class _UserPostsListViewState extends State<UserPostsListView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdatedReactionsPostBloc, UpdatedReactionsPostState>(
      listener: (context, state) {
        if (state is UpdatedReactionsPostSuccess) {
          // Actualizar el post específico en la lista del usuario
          context.read<UserPostsBloc>().add(UpdateUserPostInList(state.post));
        }
      },
      child: BlocBuilder<UserPostsBloc, UserPostsState>(
        builder: (context, state) {
          if (state is UserPostsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is UserPostsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<UserPostsBloc>().add(GetUserPosts(userId: widget.userId));
                    },
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }
          
          if (state is UserPostsSuccess) {
            if (state.posts.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.post_add, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No tienes publicaciones aún',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '¡Crea tu primera publicación!',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              );
            }
            
            return RefreshIndicator(
              onRefresh: () async {
                context.read<UserPostsBloc>().add(ReloadUserPosts(userId: widget.userId));
                // Esperar un poco para que la animación se vea
                await Future.delayed(const Duration(milliseconds: 500));
              },
              child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.posts.length,
                itemBuilder: (context, index) {
                  final post = state.posts[index];
                  return GestureDetector(
                    onTap: () async {
                      final result = await context.push('/posts/${post.id}');
                      if (result == true) {
                        // Recargar posts del usuario cuando se regrese
                        if (mounted) {
                          context.read<UserPostsBloc>().add(
                                ReloadUserPosts(userId: widget.userId),
                              );
                        }
                      }
                      // Llamar callback personalizado si existe
                      widget.onPostTap?.call(post);
                    },
                    child: PostCard(post: post),
                  );
                },
              ),
            );
          }
          
          return const Center(
            child: Text('Algo salió mal'),
          );
        },
      ),
    );
  }
}