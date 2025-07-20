import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_all_post_by_id_user_local_use_case.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_count_post_use_case.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/save_post_local_use_case.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';

part 'create_post_event.dart';
part 'create_post_state.dart';

class CreatePostBloc extends Bloc<CreatePostEvent, CreatePostState> {
  final GetCountPostUseCase getCountPostUseCase;
  final GetAllPostByIdUserLocalUseCase getAllPostByIdUserLocalUseCase;
  final SavePostLocalUseCase savePostLocalUseCase;
  final User currentUser;

  CreatePostBloc({
    required this.getCountPostUseCase,
    required this.getAllPostByIdUserLocalUseCase,
    required this.savePostLocalUseCase,
    required this.currentUser,
  }) : super(CreatePostInitial()) {
    on<CreatePostSubmitted>(_onCreatePostSubmitted);
  }

  Future<void> _onCreatePostSubmitted(
    CreatePostSubmitted event,
    Emitter<CreatePostState> emit,
  ) async {
    emit(CreatePostLoading());

    // 1. Obtener el total de posts remotos
    final remoteCountResult = await getCountPostUseCase();
    // 2. Obtener los posts locales del usuario
    final localPostsResult = await getAllPostByIdUserLocalUseCase(currentUser.id);

    int remoteCount = 0;
    int localCount = 0;

    remoteCountResult.fold((_) {}, (count) => remoteCount = count);
    localPostsResult.fold((_) {}, (posts) => localCount = posts.length);

    final newId = remoteCount + localCount + 1;

    final post = Post(
      id: newId,
      title: event.title,
      body: event.body,
      tags: event.tags,
      reactions: Reactions(likes: 0, dislikes: 0),
      views: 0,
      userId: currentUser.id,
      reactionUser: '',
    );

    final saveResult = await savePostLocalUseCase(post);

    saveResult.fold(
      (failure) => emit(CreatePostFailure('Error al guardar el post')),
      (success) => emit(CreatePostSuccess()),
    );
  }
}
