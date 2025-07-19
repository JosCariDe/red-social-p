part of 'get_post_by_id_bloc.dart';

abstract class GetPostByIdState extends Equatable {
  const GetPostByIdState();
  
  @override
  List<Object> get props => [];
}

final class GetPostByIdInitial extends GetPostByIdState {}
final class GetPostByIdLoading extends GetPostByIdState {}

final class GetPostByIdSuccess extends GetPostByIdState {

  final Post post;

  const GetPostByIdSuccess({required this.post});

  @override
  List<Object> get props => [post];

}

final class GetPostByIdError extends GetPostByIdState {

  final String message;

  const GetPostByIdError({required this.message});

  @override
  List<Object> get props => [message];

}

