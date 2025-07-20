import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_state.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/post_card.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

class PostsListView extends StatefulWidget {
  final List<Post>? posts; // Nueva propiedad opcional
  final Function(Post)? onPostTap;
  final bool enableInfiniteScroll;
  
  const PostsListView({
    super.key,
    this.posts,
    this.onPostTap,
    this.enableInfiniteScroll = true,
  });

  @override
  State<PostsListView> createState() => _PostsListViewState();
}

class _PostsListViewState extends State<PostsListView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    if (widget.enableInfiniteScroll) {
      _scrollController.addListener(_onScroll);
    }
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<GetAllPostsBloc>().add(const GetAllPosts());
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.posts != null) {
      if (widget.posts!.isEmpty) {
        return const Center(child: Text('No posts found'));
      }
      return ListView.builder(
        itemCount: widget.posts!.length,
        itemBuilder: (context, index) {
          final post = widget.posts![index];
          return GestureDetector(
            onTap: () => widget.onPostTap?.call(post),
            child: PostCard(post: post),
          );
        },
      );
    }
    return BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
      builder: (context, state) {
        if (state is GetAllPostsInitial ||
            (state is GetAllPostsLoading && state is! GetAllPostsSuccess)) {
          return const Center(child: CircularProgressIndicator());
        }
        
        if (state is GetAllPostsError) {
          return Center(child: Text(state.message));
        }
        
        if (state is GetAllPostsSuccess) {
          if (state.posts.isEmpty) {
            return const Center(child: Text('No posts found'));
          }
          
          return ListView.builder(
            controller: _scrollController,
            itemCount: widget.enableInfiniteScroll
                ? (state.limitReached
                    ? state.posts.length
                    : state.posts.length + 1)
                : state.posts.length,
            itemBuilder: (context, index) {
              if (index >= state.posts.length) {
                return const Center(child: CircularProgressIndicator());
              }
              
              final post = state.posts[index];
              return GestureDetector(
                onTap: () async {
                  final result = await context.push('/posts/${post.id}');
                  if (result == true) {
                    context.read<GetAllPostsBloc>().add(ReloadPosts());
                  }
                  // Llamar callback personalizado si existe
                  widget.onPostTap?.call(post);
                },
                child: PostCard(post: post),
              );
            },
          );
        }
        
        return const Center(child: Text('Something went wrong'));
      },
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}