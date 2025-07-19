import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_all_post_use_case.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_state.dart';
import 'package:stream_transform/stream_transform.dart';

const throttleDuration = Duration(milliseconds: 100);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class GetAllPostsBloc extends Bloc<GetAllPostsEvent, GetAllPostsState> {
  final GetAllPostUseCase getAllPostUseCase;

  GetAllPostsBloc({required this.getAllPostUseCase})
      : super(GetAllPostsInitial()) {
    on<GetAllPosts>(
      _onGetAllPosts,
      transformer: throttleDroppable(throttleDuration),
    );
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
        emit(GetAllPostsLoading());
        final result = await getAllPostUseCase(limit: event.limit, skip: 0);
        return result.fold(
          (failure) => emit(GetAllPostsError(message: 'Error al cargar los posts')),
          (posts) => emit(GetAllPostsSuccess(posts: posts, limitReached: false)),
        );
      }

      if (currentState is GetAllPostsSuccess) {
        final result = await getAllPostUseCase(limit: event.limit, skip: currentState.posts.length);
        result.fold(
          (failure) => emit(GetAllPostsError(message: 'Error al cargar los posts')),
          (posts) {
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
