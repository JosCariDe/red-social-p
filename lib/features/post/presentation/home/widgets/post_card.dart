import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';

class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  void _handleReaction(BuildContext context, String newReaction) {
    context.read<UpdatedReactionsPostBloc>().add(
          UpdateReaction(
            idPost: post.id,
            reactionUser: newReaction == post.reactionUser ? '' : newReaction,
            postUpdated: post,
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<UpdatedReactionsPostBloc, UpdatedReactionsPostState>(
      buildWhen: (prev, curr) {
        // Solo reconstruye si el post actualizado es este
        if (curr is UpdatedReactionsPostSuccess) {
          return curr.post.id == post.id;
        }
        return false;
      },
      builder: (context, state) {
        final currentPost = state is UpdatedReactionsPostSuccess
            ? state.post
            : post;

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(
              color: colorScheme.onSurface.withOpacity(0.1),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(currentPost.title, style: textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(currentPost.body, style: textTheme.bodyMedium),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'ID: ${currentPost.id}',
                      style: textTheme.bodySmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    Row(
                      children: [
                        ReactionIcon(
                          isActive: currentPost.reactionUser == 'like',
                          iconActive: Icons.thumb_up_alt,
                          iconInactive: Icons.thumb_up_alt_outlined,
                          color: colorScheme.primary,
                          onTap: () =>
                              _handleReaction(context, 'like'),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          currentPost.reactions.likes.toString(),
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(width: 16),
                        ReactionIcon(
                          isActive: currentPost.reactionUser == 'dislike',
                          iconActive: Icons.thumb_down_alt,
                          iconInactive: Icons.thumb_down_alt_outlined,
                          color: colorScheme.error,
                          onTap: () =>
                              _handleReaction(context, 'dislike'),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          currentPost.reactions.dislikes.toString(),
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
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
          size: 18,
          color: color,
        ),
      ),
    );
  }
}
