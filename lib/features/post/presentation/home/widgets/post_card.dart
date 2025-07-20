import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
            color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt())),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.post.title,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              widget.post.body,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${widget.post.id}',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          final newReaction =
                              widget.post.reactionUser == 'like' ? '' : 'like';
                          context.read<UpdatedReactionsPostBloc>().add(
                                UpdateReaction(
                                  idPost: widget.post.id,
                                  reactionUser: newReaction,
                                ),
                              );
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Icon(
                          widget.post.reactionUser == 'like'
                              ? Icons.thumb_up_alt
                              : Icons.thumb_up_alt_outlined,
                          key: ValueKey<String>(
                              widget.post.reactionUser == 'like'
                                  ? 'liked'
                                  : 'unliked'),
                          size: 18,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(widget.post.reactions.likes.toString(),
                        style: textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    InkWell(
                      onTap: () {
                        setState(() {
                          final newReaction =
                              widget.post.reactionUser == 'dislike'
                                  ? ''
                                  : 'dislike';
                          context.read<UpdatedReactionsPostBloc>().add(
                                UpdateReaction(
                                  idPost: widget.post.id,
                                  reactionUser: newReaction,
                                ),
                              );
                        });
                      },
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder:
                            (Widget child, Animation<double> animation) {
                          return ScaleTransition(
                              scale: animation, child: child);
                        },
                        child: Icon(
                          widget.post.reactionUser == 'dislike'
                              ? Icons.thumb_down_alt
                              : Icons.thumb_down_alt_outlined,
                          key: ValueKey<String>(
                              widget.post.reactionUser == 'dislike'
                                  ? 'disliked'
                                  : 'undisliked'),
                          size: 18,
                          color: colorScheme.error,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(widget.post.reactions.dislikes.toString(),
                        style: textTheme.bodyMedium),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
