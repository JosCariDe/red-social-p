import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/update_reaction_post_use_case.dart';

part 'updated_reactions_post_event.dart';
part 'updated_reactions_post_state.dart';

class UpdatedReactionsPostBloc
    extends Bloc<UpdatedReactionsPostEvent, UpdatedReactionsPostState> {
  final UpdateReactionPostUseCase updateReactionPostUseCase;

  UpdatedReactionsPostBloc({required this.updateReactionPostUseCase})
    : super(UpdatedReactionsPostInitial()) {
    on<UpdateReaction>(_onUpdateReaction);
  }

  Future<void> _onUpdateReaction(
    UpdateReaction event,
    Emitter<UpdatedReactionsPostState> emit,
  ) async {
    emit(UpdatedReactionsPostLoading());
    final failureOrSuccess = await updateReactionPostUseCase(
      event.idPost,
      reactionUser: event.reactionUser,
    );
    failureOrSuccess.fold(
      (failure) => emit(UpdatedReactionsPostError(message: failure.toString())),
      (success) => emit(UpdatedReactionsPostSuccess()),
    );
  }
}
