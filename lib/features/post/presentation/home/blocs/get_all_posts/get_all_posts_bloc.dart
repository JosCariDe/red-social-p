import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_all_post_use_case.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_state.dart';

class GetAllPostsBloc extends Bloc<GetAllPostsEvent, GetAllPostsState> {
  final GetAllPostUseCase getAllPostUseCase;

  GetAllPostsBloc({required this.getAllPostUseCase})
      : super(GetAllPostsInitial()) {
    on<GetAllPosts>(_onGetAllPosts);
  }

  Future<void> _onGetAllPosts(
    GetAllPosts event,
    Emitter<GetAllPostsState> emit,
  ) async {
    final currentState = state;
    if (currentState is GetAllPostsSuccess && currentState.limitReached) {
      return;
    }

    try {
      if (currentState is GetAllPostsInitial) {
        emit(GetAllPostsLoading());             //? Aqui se maneja la paginacion, skip 0 para no permitir que de alguna manera se pierdan algunos post en la primera carga
        final result = await getAllPostUseCase(limit: event.limit, skip: 0);
        return result.fold(
          (failure) => emit(GetAllPostsError(message: 'Error al cargar los posts')),
          (posts) => emit(GetAllPostsSuccess(posts: posts, limitReached: false)),
        );
      }

      if (currentState is GetAllPostsSuccess) {
        //? Aquí skip si es del tamaño del arreglo de post, para cargar los proximos 10, si es que el limit sigue siendo 10
        final result = await getAllPostUseCase(limit: event.limit, skip: currentState.posts.length);
        result.fold(
          (failure) => emit(GetAllPostsError(message: 'Error al cargar los posts')),
          (posts) {
            //? Detectar cuando llegamos al maximo de videos que se pueden cargar
            if (posts.isEmpty) {
              emit(currentState.copyWith(limitReached: true));
            } else {
              emit(
                currentState.copyWith(
                  posts: List.of(currentState.posts)..addAll(posts),
                  limitReached: false,
                ),
              );
            }
          },
        );
      }
    } catch (_) {
      emit(GetAllPostsError(message: 'Error inesperado al cargar los posts'));
    }
  }
}
