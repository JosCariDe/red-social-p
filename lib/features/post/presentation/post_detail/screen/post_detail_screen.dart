import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/post_detail/blocs/get_one_post_by_id/get_post_by_id_bloc.dart';

class PostDetailScreen extends StatefulWidget {
  final int idPost;

  const PostDetailScreen({super.key, required this.idPost});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  static final Map<int, int> _comentariosPorPost = {};

  int _getComentariosParaPost(int postId) {
    if (!_comentariosPorPost.containsKey(postId)) {
      _comentariosPorPost[postId] = Random(
        postId,
      ).nextInt(20); // Semilla por id
    }
    return _comentariosPorPost[postId]!;
  }

  @override
  void initState() {
    super.initState();
    context.read<GetPostByIdBloc>().add(GetPostById(idPost: widget.idPost));
  }

  void _handleReaction(BuildContext context, Post post, String newReaction) {
    context.read<UpdatedReactionsPostBloc>().add(
      UpdateReaction(
        idPost: post.id,
        reactionUser: newReaction,
        postUpdated: post,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final comentarios = _getComentariosParaPost(widget.idPost);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del Post')),
      body: BlocListener<UpdatedReactionsPostBloc, UpdatedReactionsPostState>(
        listener: (context, state) {
          if (state is UpdatedReactionsPostSuccess) {
            final postId = widget.idPost;
            if (state.post.id == postId) {
              context.read<GetPostByIdBloc>().add(UpdatePostDetail(state.post));
            }
          }
        },
        child: BlocBuilder<GetPostByIdBloc, GetPostByIdState>(
          builder: (context, state) {
            if (state is GetPostByIdLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is GetPostByIdError) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is GetPostByIdSuccess) {
              final post = state.post;

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.title, style: textTheme.headlineMedium),
                    const SizedBox(height: 12),
                    Text(post.body, style: textTheme.bodyLarge),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ReactionIcon(
                          isActive: post.reactionUser == 'like',
                          iconActive: Icons.thumb_up_alt,
                          iconInactive: Icons.thumb_up_alt_outlined,
                          color: colorScheme.primary,
                          onTap: () => _handleReaction(context, post, 'like'),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.reactions.likes.toString(),
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        ReactionIcon(
                          isActive: post.reactionUser == 'dislike',
                          iconActive: Icons.thumb_down_alt,
                          iconInactive: Icons.thumb_down_alt_outlined,
                          color: colorScheme.error,
                          onTap: () =>
                              _handleReaction(context, post, 'dislike'),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          post.reactions.dislikes.toString(),
                          style: textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        const Icon(Icons.comment_outlined, size: 20),
                        const SizedBox(width: 4),
                        Text(
                          '$comentarios comentarios',
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }

            return const Center(child: Text('Cargando...'));
          },
        ),
      ),
    );
  }
}

class ReactionIcon extends StatelessWidget {
  final bool isActive;
  final IconData iconActive;
  final IconData iconInactive;
  final Color color;
  final VoidCallback onTap;

  const ReactionIcon({
    super.key,
    required this.isActive,
    required this.iconActive,
    required this.iconInactive,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isActive ? iconActive : iconInactive,
          key: ValueKey<bool>(isActive),
          size: 20,
          color: color,
        ),
      ),
    );
  }
}
