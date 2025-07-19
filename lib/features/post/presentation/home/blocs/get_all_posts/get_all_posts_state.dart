import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

abstract class GetAllPostsState extends Equatable {
  const GetAllPostsState();

  @override
  List<Object> get props => [];
}

class GetAllPostsInitial extends GetAllPostsState {}

class GetAllPostsLoading extends GetAllPostsState {}

class GetAllPostsSuccess extends GetAllPostsState {
  final List<Post> posts;
  final bool limitReached;

  const GetAllPostsSuccess({
    this.posts = const <Post>[],
    this.limitReached = false,
  });

  GetAllPostsSuccess copyWith({List<Post>? posts, bool? limitReached}) {
    return GetAllPostsSuccess(
      posts: posts ?? this.posts,
      limitReached: limitReached ?? this.limitReached,
    );
  }

  @override
  List<Object> get props => [posts, limitReached];
}

class GetAllPostsError extends GetAllPostsState {
  final String message;

  const GetAllPostsError({required this.message});

  @override
  List<Object> get props => [message];
}
