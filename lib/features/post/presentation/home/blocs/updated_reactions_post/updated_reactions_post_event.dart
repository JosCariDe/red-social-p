part of 'updated_reactions_post_bloc.dart';

sealed class UpdatedReactionsPostEvent extends Equatable {
  const UpdatedReactionsPostEvent();

  @override
  List<Object> get props => [];
}

class UpdateReaction extends UpdatedReactionsPostEvent {
  final int idPost;
  final String reactionUser;
  final Post postUpdated;

  const UpdateReaction({required this.idPost, required this.reactionUser, required this.postUpdated});

  @override
  List<Object> get props => [idPost, reactionUser];
}
