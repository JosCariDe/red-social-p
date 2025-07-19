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

  const GetAllPostsSuccess({required this.posts});

  @override
  List<Object> get props => [posts];
}

class GetAllPostsError extends GetAllPostsState {
  final String message;

  const GetAllPostsError({required this.message});

  @override
  List<Object> get props => [message];
}