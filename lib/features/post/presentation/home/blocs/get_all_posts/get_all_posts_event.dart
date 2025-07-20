import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

abstract class GetAllPostsEvent extends Equatable {
  const GetAllPostsEvent();

  @override
  List<Object> get props => [];
}

class GetAllPosts extends GetAllPostsEvent {
  final int limit;
  final int skip;

  const GetAllPosts({this.limit = 10, this.skip = 0});

  @override
  List<Object> get props => [limit, skip];
}

class UpdatePostInList extends GetAllPostsEvent {
  final Post updatedPost;
  const UpdatePostInList(this.updatedPost);

  @override
  List<Object> get props => [updatedPost];
}
