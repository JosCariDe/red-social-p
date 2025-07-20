import 'package:get_it/get_it.dart';
import 'package:red_social_prueba/config/exports/exports_data.dart';
import 'package:red_social_prueba/core/db/local/posts_database.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_one_post_by_id_use_case.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/update_reaction_post_use_case.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/updated_reactions_post/updated_reactions_post_bloc.dart';
import 'package:red_social_prueba/features/post/presentation/post_detail/blocs/get_one_post_by_id/get_post_by_id_bloc.dart';
import 'package:red_social_prueba/features/user/data/data_sources/local/user_local_data_source.dart';
import 'package:red_social_prueba/features/user/data/data_sources/local/user_shared_preference_data_source_impl.dart';
import 'package:red_social_prueba/features/user/data/repositories/user_repository_impl.dart';
import 'package:red_social_prueba/features/user/domain/repositories/user_repository.dart';
import 'package:red_social_prueba/features/user/domain/uses_cases/delete_user_case.dart';
import 'package:red_social_prueba/features/user/domain/uses_cases/get_user_use_case.dart';
import 'package:red_social_prueba/features/user/domain/uses_cases/save_user_use_case.dart';
import 'package:red_social_prueba/features/user/presentation/login/blocs/login_bloc/login_bloc.dart';
// Importa aquí todas tus dependencias y casos de uso

final sl = GetIt.instance;

Future<void> init() async {
  // Data sources POSTS
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
  // Data sources USER
  sl.registerLazySingleton<UserLocalDataSource>(() => UserSharedPreferenceDataSourceImpl());
  // Repository USER
  sl.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(userLocalDataSource: sl()));
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
  // Casos de uso USER
  sl.registerLazySingleton<SaveUserUseCase>(() => SaveUserUseCase(userRepository: sl()));
  sl.registerLazySingleton<GetUserUseCase>(() => GetUserUseCase(userRepository: sl()));
  sl.registerLazySingleton<DeleteUserCase>(() => DeleteUserCase(userRepository: sl()));

  // Blocs
  sl.registerFactory(() => GetAllPostsBloc(getAllPostUseCase: sl()));
  sl.registerFactory(
    () => UpdatedReactionsPostBloc(updateReactionPostUseCase: sl()),
  );
  sl.registerFactory(() => GetPostByIdBloc(getOnePostByIdUseCase: sl()));
  sl.registerFactory(() => LoginBloc(saveUserUseCase: sl()));
}
