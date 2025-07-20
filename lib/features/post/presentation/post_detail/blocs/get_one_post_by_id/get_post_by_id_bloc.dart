import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/get_one_post_by_id_use_case.dart';

part 'get_post_by_id_event.dart';
part 'get_post_by_id_state.dart';

class GetPostByIdBloc extends Bloc<GetPostByIdEvent, GetPostByIdState> {
  final GetOnePostByIdUseCase getOnePostByIdUseCase;

  GetPostByIdBloc({required this.getOnePostByIdUseCase})
    : super(GetPostByIdInitial()) {
    on<GetPostById>(_onGetOnePostById);
    on<UpdatePostDetail>((event, emit) {
      emit(GetPostByIdSuccess(post: event.updatedPost));
    });
  }

  Future<void> _onGetOnePostById(
    GetPostById event,
    Emitter<GetPostByIdState> emit,
  ) async {
    emit(GetPostByIdLoading());
    final failureOrPost = await getOnePostByIdUseCase(event.idPost);
    failureOrPost.fold(
      (failure) =>
          emit(GetPostByIdError(message: 'Error al cargar un post con id')),
      (post) => emit(GetPostByIdSuccess(post: post)),
    );
  }
}
