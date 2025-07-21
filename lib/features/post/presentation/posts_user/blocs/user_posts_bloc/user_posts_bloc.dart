import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_all_post_by_id_user_local_use_case.dart';

part 'user_posts_event.dart';
part 'user_posts_state.dart';

class UserPostsBloc extends Bloc<UserPostsEvent, UserPostsState> {
  final GetAllPostByIdUserLocalUseCase getAllPostByIdUserLocalUseCase;

  UserPostsBloc({required this.getAllPostByIdUserLocalUseCase})
    : super(UserPostsInitial()) {
    on<GetUserPosts>(_onGetUserPosts);
    on<UpdateUserPostInList>(_onUpdateUserPostInList);
    on<ReloadUserPosts>(_onReloadUserPosts);
    on<ResetUserPosts>((event, emit) {
      emit(UserPostsInitial());
    });
  }

  Future<void> _onGetUserPosts(
    GetUserPosts event,
    Emitter<UserPostsState> emit,
  ) async {
    emit(UserPostsLoading());
    final result = await getAllPostByIdUserLocalUseCase(event.userId);
    result.fold(
      (failure) => emit(
        const UserPostsError(
          'Error al cargar los posts desde el Bloc UserPostBLoC',
        ),
      ),
      (posts) => emit(UserPostsSuccess(posts)),
    );
  }

  Future<void> _onUpdateUserPostInList(
    UpdateUserPostInList event,
    Emitter<UserPostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is UserPostsSuccess) {
      // Buscar y actualizar el post específico en la lista
      final updatedPosts = currentState.posts.map((post) {
        return post.id == event.post.id ? event.post : post;
      }).toList();

      emit(UserPostsSuccess(updatedPosts));
    }
  }

  Future<void> _onReloadUserPosts(
    ReloadUserPosts event,
    Emitter<UserPostsState> emit,
  ) async {
    // No mostrar loading si ya hay posts cargados para mejor UX
    final currentState = state;
    if (currentState is! UserPostsSuccess) {
      emit(UserPostsLoading());
    }

    final result = await getAllPostByIdUserLocalUseCase(event.userId);
    result.fold(
      (failure) => emit(const UserPostsError('Error al recargar los posts')),
      (posts) => emit(UserPostsSuccess(posts)),
    );
  }
}
