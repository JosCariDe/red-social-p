import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_all_post_use_case.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_event.dart';
import 'package:red_social_prueba/features/post/presentation/home/blocs/get_all_posts/get_all_posts_state.dart';

class GetAllPostsBloc extends Bloc<GetAllPostsEvent, GetAllPostsState> {
  final GetAllPostUseCase getAllPostUseCase;

  GetAllPostsBloc({required this.getAllPostUseCase})
      : super(GetAllPostsInitial()) {
    on<GetAllPosts>((event, emit) async {
      emit(GetAllPostsLoading());
      final result = await getAllPostUseCase();
      result.fold(
        (failure) => emit(GetAllPostsError(message: 'Error al cargar los posts')),
        (posts) => emit(GetAllPostsSuccess(posts: posts)),
      );
    });
  }
}
