import 'package:flutter/material.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colorScheme.onSurface.withAlpha((0.1 * 255).toInt())),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              post.body,
              style: textTheme.bodyMedium,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'ID: ${post.id}',
                  style: textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt_outlined,
                        size: 18, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(post.reactions.likes.toString(),
                        style: textTheme.bodyMedium),
                    const SizedBox(width: 16),
                    Icon(Icons.thumb_down_alt_outlined,
                        size: 18, color: colorScheme.error),
                    const SizedBox(width: 4),
                    Text(post.reactions.dislikes.toString(),
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
