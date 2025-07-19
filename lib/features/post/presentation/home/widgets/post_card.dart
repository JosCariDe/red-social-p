import 'package:flutter/material.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

class PostCard extends StatelessWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(post.body),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Icon(Icons.thumb_up_alt_outlined, size: 16),
                const SizedBox(width: 4),
                Text(post.reactions.likes.toString()),
                const SizedBox(width: 16),
                const Icon(Icons.thumb_down_alt_outlined, size: 16),
                const SizedBox(width: 4),
                Text(post.reactions.dislikes.toString()),
              ],
            )
          ],
        ),
      ),
    );
  }
}
