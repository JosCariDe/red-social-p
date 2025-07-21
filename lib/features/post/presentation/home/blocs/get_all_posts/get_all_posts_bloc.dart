import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_all_post_use_case.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_state.dart';

class GetAllPostsBloc extends Bloc<GetAllPostsEvent, GetAllPostsState> {
  final GetAllPostUseCase getAllPostUseCase;

  GetAllPostsBloc({required this.getAllPostUseCase})
    : super(GetAllPostsInitial()) {
    on<GetAllPosts>(_onGetAllPosts);
    on<UpdatePostInList>((event, emit) {
      final currentState = state;
      if (currentState is GetAllPostsSuccess) {
        final updatedPosts = currentState.posts
            .map(
              (post) =>
                  post.id == event.updatedPost.id ? event.updatedPost : post,
            )
            .toList();
        emit(currentState.copyWith(posts: updatedPosts));
      }
    });
    on<ReloadPosts>((event, emit) async {
      emit(GetAllPostsLoading());
      final result = await getAllPostUseCase(limit: 10, skip: 0);
      result.fold(
        (failure) =>
            emit(GetAllPostsError(message: 'Error al cargar los posts')),
        (posts) => emit(GetAllPostsSuccess(posts: posts, limitReached: false)),
      );
    });
    on<ResetPosts>((event, emit) {
      emit(GetAllPostsInitial());
    });
  }

  Future<void> _onGetAllPosts(
    GetAllPosts event,
    Emitter<GetAllPostsState> emit,
  ) async {
    final currentState = state;
    //? Si llegó al limite de post de la api
    if (currentState is GetAllPostsSuccess && currentState.limitReached) {
      return;
    }

    try {
      if (currentState is GetAllPostsInitial) {
        emit(
          GetAllPostsLoading(),
        ); //? Aqui se maneja la paginacion, skip 0 para no permitir que de alguna manera se pierdan algunos post en la primera carga
        final result = await getAllPostUseCase(limit: event.limit, skip: 0);
        return result.fold(
          (failure) =>
              emit(GetAllPostsError(message: 'Error al cargar los posts')),
          (posts) =>
              emit(GetAllPostsSuccess(posts: posts, limitReached: false)),
        );
      }

      if (currentState is GetAllPostsSuccess) {
        final result = await getAllPostUseCase(
          limit: event.limit,
          skip: currentState.posts.length,
        );

        result.fold(
          (failure) =>
              emit(GetAllPostsError(message: 'Error al cargar los posts')),
          (posts) {
            if (posts.isEmpty) {
              emit(currentState.copyWith(limitReached: true));
            } else {
              // Combina los posts existentes y los nuevos
              final combinedPosts = List<Post>.from(currentState.posts)
                ..addAll(posts);

              // Elimina duplicados por id usando un Map
              final uniquePostsMap = {
                for (var post in combinedPosts) post.id: post,
              };
              final uniquePosts = uniquePostsMap.values.toList();

              emit(
                currentState.copyWith(posts: uniquePosts, limitReached: false),
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
