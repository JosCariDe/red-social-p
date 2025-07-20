part of 'create_post_bloc.dart';

abstract class CreatePostState extends Equatable {
  @override
  List<Object> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoading extends CreatePostState {}

class CreatePostSuccess extends CreatePostState {}

class CreatePostFailure extends CreatePostState {
  final String message;
  CreatePostFailure(this.message);

  @override
  List<Object> get props => [message];
}