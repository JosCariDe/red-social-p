part of 'user_posts_bloc.dart';

abstract class UserPostsState extends Equatable {
  const UserPostsState();

  @override
  List<Object> get props => [];
}

class UserPostsInitial extends UserPostsState {}

class UserPostsLoading extends UserPostsState {}

class UserPostsSuccess extends UserPostsState {
  final List<Post> posts;

  const UserPostsSuccess(this.posts);

  @override
  List<Object> get props => [posts];
}

class UserPostsError extends UserPostsState {
  final String message;

  const UserPostsError(this.message);

  @override
  List<Object> get props => [message];
}
