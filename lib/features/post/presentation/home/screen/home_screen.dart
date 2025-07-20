import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_state.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/post_card.dart';
import 'package:red_social_prueba/features/post/presentation/post_detail/screen/post_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<GetAllPostsBloc>().add(GetAllPosts());
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<GetAllPostsBloc>().add(const GetAllPosts());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Posts')),
      body: BlocListener<UpdatedReactionsPostBloc, UpdatedReactionsPostState>(
        listener: (context, state) {
          if (state is UpdatedReactionsPostSuccess) {
            context.read<GetAllPostsBloc>().add(UpdatePostInList(state.post));
          }
        },
        child: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
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
                itemCount: state.limitReached
                    ? state.posts.length
                    : state.posts.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.posts.length) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final post = state.posts[index];
                  return GestureDetector(
                    onTap: () {
                      context.push('/posts/${post.id}');
                    },
                    child: PostCard(post: post),
                  );
                },
              );
            }
            return const Center(child: Text('Something went wrong'));
          },
        ),
      ),
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
