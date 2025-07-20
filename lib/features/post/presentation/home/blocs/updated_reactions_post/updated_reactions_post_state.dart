part of 'updated_reactions_post_bloc.dart';

sealed class UpdatedReactionsPostState extends Equatable {
  const UpdatedReactionsPostState();

  @override
  List<Object> get props => [];
}

final class UpdatedReactionsPostInitial extends UpdatedReactionsPostState {}

final class UpdatedReactionsPostLoading extends UpdatedReactionsPostState {}

final class UpdatedReactionsPostSuccess extends UpdatedReactionsPostState {
  final Post post;

  const UpdatedReactionsPostSuccess({required this.post});

  @override
  List<Object> get props => [post];
}

final class UpdatedReactionsPostError extends UpdatedReactionsPostState {
  final String message;

  const UpdatedReactionsPostError({required this.message});

  @override
  List<Object> get props => [message];
}
