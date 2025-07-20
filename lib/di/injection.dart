import 'package:get_it/get_it.dart';
import 'package:red_social_prueba/config/exports/exports_data.dart';
import 'package:red_social_prueba/core/db/local/posts_database.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_one_post_by_id_use_case.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/update_reaction_post_use_case.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/post_detail/blocs/get_one_post_by_id/get_post_by_id_bloc.dart';
// Importa aquí todas tus dependencias y casos de uso

final sl = GetIt.instance;

Future<void> init() async {
  // Data sources
  sl.registerLazySingleton<PostsDatabase>(() => PostsDatabase.instance);
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostHttpDataSourceImpl(),
  );
  sl.registerLazySingleton<PostLocalDataSource>(
    () => PostSqliteDataSourceImpl(database: sl()),
  );
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(
      postLocalDataSource: sl(),
      postRemoteDataSource: sl(),
    ),
  );

  // Use cases
  sl.registerLazySingleton<GetAllPostUseCase>(
    () => GetAllPostUseCase(postRepository: sl()),
  );
  sl.registerLazySingleton<UpdateReactionPostUseCase>(
    () => UpdateReactionPostUseCase(repository: sl()),
  );
  sl.registerLazySingleton<GetOnePostByIdUseCase>(
    () => GetOnePostByIdUseCase(postRepository: sl()),
  );

  // Blocs
  sl.registerFactory(() => GetAllPostsBloc(getAllPostUseCase: sl()));
  sl.registerFactory(
    () => UpdatedReactionsPostBloc(updateReactionPostUseCase: sl()),
  );
  sl.registerFactory(() => GetPostByIdBloc(getOnePostByIdUseCase: sl()));
}
