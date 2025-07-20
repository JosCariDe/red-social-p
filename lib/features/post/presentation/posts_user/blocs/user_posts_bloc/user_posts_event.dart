part of 'user_posts_bloc.dart';

abstract class UserPostsEvent extends Equatable {
  const UserPostsEvent();

  @override
  List<Object> get props => [];
}

class GetUserPosts extends UserPostsEvent {
  final int userId;

  const GetUserPosts({required this.userId});

  @override
  List<Object> get props => [userId];
}

class UpdateUserPostInList extends UserPostsEvent {
  final Post post;

  const UpdateUserPostInList(this.post);

  @override
  List<Object> get props => [post];
}

class ReloadUserPosts extends UserPostsEvent {
  final int userId;

  const ReloadUserPosts({required this.userId});

  @override
  List<Object> get props => [userId];
}

class ResetUserPosts extends UserPostsEvent {}
