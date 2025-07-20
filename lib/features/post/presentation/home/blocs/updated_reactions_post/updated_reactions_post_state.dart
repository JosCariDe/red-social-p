part of 'updated_reactions_post_bloc.dart';

sealed class UpdatedReactionsPostState extends Equatable {
  const UpdatedReactionsPostState();

  @override
  List<Object> get props => [];
}

final class UpdatedReactionsPostInitial extends UpdatedReactionsPostState {}

final class UpdatedReactionsPostLoading extends UpdatedReactionsPostState {}

final class UpdatedReactionsPostSuccess extends UpdatedReactionsPostState {}

final class UpdatedReactionsPostError extends UpdatedReactionsPostState {
  final String message;

  const UpdatedReactionsPostError({required this.message});

  @override
  List<Object> get props => [message];
}
