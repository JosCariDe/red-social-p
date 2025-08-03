import 'package:get_it/get_it.dart';
import 'package:red_social_prueba/config/exports/exports_data.dart';
import 'package:red_social_prueba/core/db/local/posts_database.dart';
import 'package:red_social_prueba/features/user/domain/uses_cases/delete_all_user_case.dart';
import 'package:red_social_prueba/features/user/domain/uses_cases/get_all_user_use_case.dart';

import 'barril_dependencias.dart';

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
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserSharedPreferenceDataSourceImpl(),
  );
  // Repository USER
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(userLocalDataSource: sl()),
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
  sl.registerLazySingleton<GetCountPostUseCase>(
    () => GetCountPostUseCase(postRepository: sl()),
  );
  
  sl.registerLazySingleton<GetAllPostByIdUserLocalUseCase>(
    () => GetAllPostByIdUserLocalUseCase(postRepository: sl()),
  );

  sl.registerLazySingleton<SavePostLocalUseCase>(
    () => SavePostLocalUseCase(postRepository: sl()),
  );
  sl.registerLazySingleton<DeletePostsLocalUseCase>(
    () => DeletePostsLocalUseCase(postRepository: sl()),
  );
  
  // Casos de uso USER
  sl.registerLazySingleton<SaveUserUseCase>(
    () => SaveUserUseCase(userRepository: sl()),
  );
  sl.registerLazySingleton<GetUserUseCase>(
    () => GetUserUseCase(userRepository: sl()),
  );
  sl.registerLazySingleton<DeleteUserCase>(
    () => DeleteUserCase(userRepository: sl()),
  );

  sl.registerLazySingleton<DeleteAllUserCase>(
    () => DeleteAllUserCase(userRepository: sl()),
  );

  sl.registerLazySingleton<GetAllUserUseCase>(
    () => GetAllUserUseCase(userRepository: sl()),
  );
  // Blocs
  //? GLOBAL:
  sl.registerLazySingleton(() => AuthUserBloc(getAllUserUseCase: sl()));
  //? OTROS
  sl.registerFactory(() => GetAllPostsBloc(getAllPostUseCase: sl()));
  sl.registerFactory(
    () => UpdatedReactionsPostBloc(updateReactionPostUseCase: sl()),
  );
  sl.registerFactory(() => GetPostByIdBloc(getOnePostByIdUseCase: sl()));
  sl.registerFactory(() => LoginBloc(saveUserUseCase: sl()));
  sl.registerFactory(
    () => CreatePostBloc(
      getAllPostByIdUserLocalUseCase: sl(),
      getCountPostUseCase: sl(),
      savePostLocalUseCase: sl(),
      userId: 0, // valor dummy, lo sobreescribes en la ruta
    ),
  );
  sl.registerFactory(() => UserPostsBloc(getAllPostByIdUserLocalUseCase: sl()));
  sl.registerFactory(() => LogoutBloc(deletePostsLocalUseCase: sl(), deleteAllUserCase: sl()));
}
