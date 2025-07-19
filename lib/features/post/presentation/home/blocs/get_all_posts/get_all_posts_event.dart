import 'package:equatable/equatable.dart';

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
