import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/config/router/app_router.dart';
import 'package:red_social_prueba/config/theme/app_theme.dart';
import 'package:red_social_prueba/core/db/local/posts_database.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/update_reaction_post_use_case.dart';

import 'config/exports/exports_data.dart'; // Archivo de barril para importaciones


void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<PostsDatabase>(
          create: (context) => PostsDatabase.instance,
        ),
        RepositoryProvider<PostRemoteDataSource>(
          create: (context) => PostHttpDataSourceImpl(),
        ),
        RepositoryProvider<PostLocalDataSource>(
          create: (context) => PostSqliteDataSourceImpl(
            database: context.read<PostsDatabase>(),
          ),
        ),
        RepositoryProvider<PostRepository>(
          create: (context) => PostRepositoryImpl(
            postLocalDataSource: context.read<PostLocalDataSource>(),
            postRemoteDataSource: context.read<PostRemoteDataSource>(),
          ),
        ),
        RepositoryProvider<GetAllPostUseCase>(
          create: (context) => GetAllPostUseCase(
            postRepository: context.read<PostRepository>(),
          ),
        ),
        RepositoryProvider<UpdateReactionPostUseCase>(
          create: (context) => UpdateReactionPostUseCase(
            repository: context.read<PostRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GetAllPostsBloc>(
            create: (context) => GetAllPostsBloc(
              getAllPostUseCase: context.read<GetAllPostUseCase>(),
            ),
          ),
          BlocProvider<UpdatedReactionsPostBloc>(
            create: (context) => UpdatedReactionsPostBloc(
              updateReactionPostUseCase: context.read<UpdateReactionPostUseCase>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: appRouter,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkTheme,
        ),
      ),
    );
  }
}
