import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';

class CreatePostFab extends StatelessWidget {
  final VoidCallback? onPostCreated;
  final IconData? icon;
  final String? tooltip;

  const CreatePostFab({
    super.key,
    this.onPostCreated,
    this.icon = Icons.add,
    this.tooltip = 'Crear nuevo post',
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      heroTag: "home_fab",
      onPressed: () async {
        final result = await context.push('/create-post');
        if (result == true) {
          context.read<GetAllPostsBloc>().add(ReloadPosts());
          // Llamar callback personalizado si existe
          onPostCreated?.call();
        }
      },
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}