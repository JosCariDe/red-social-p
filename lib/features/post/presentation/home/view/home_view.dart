import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_state.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/post_card.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<GetAllPostsBloc>().add(const GetAllPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: BlocBuilder<GetAllPostsBloc, GetAllPostsState>(
        builder: (context, state) {
          if (state is GetAllPostsInitial || state is GetAllPostsLoading) {
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
                return PostCard(post: post);
              },
            );
          }
          return const Center(child: Text('Something went wrong'));
        },
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

  void _onScroll() {
    if (_isBottom) {
      context.read<GetAllPostsBloc>().add(const GetAllPosts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }
}
