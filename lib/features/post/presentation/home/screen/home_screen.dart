import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/create_post_fab.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/home_app_bar.dart';
import 'package:red_social_prueba/features/post/presentation/home/widgets/posts_list_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<GetAllPostsBloc>().add(GetAllPosts());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const HomeAppBar(),
      floatingActionButton: CreatePostFab(
        onPostCreated: () {
          // Callback personalizado cuando se crea un post
          debugPrint('Post creado desde HomeScreen');
        },
      ),
      body: BlocListener<UpdatedReactionsPostBloc, UpdatedReactionsPostState>(
        listener: (context, state) {
          if (state is UpdatedReactionsPostSuccess) {
            context.read<GetAllPostsBloc>().add(UpdatePostInList(state.post));
          }
        },
        child: const PostsListView(
          enableInfiniteScroll: true,
        ),
      ),
    );
  }
}