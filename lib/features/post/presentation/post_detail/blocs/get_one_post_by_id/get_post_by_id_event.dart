part of 'get_post_by_id_bloc.dart';

sealed class GetPostByIdEvent extends Equatable {
  const GetPostByIdEvent();

  @override
  List<Object> get props => [];
}

final class GetPostById extends GetPostByIdEvent {

  final int idPost;

  const GetPostById({required this.idPost});

  @override
  List<Object> get props => [idPost];

}

final class UpdatePostDetail extends GetPostByIdEvent {
  final Post updatedPost;
  const UpdatePostDetail(this.updatedPost);

  @override
  List<Object> get props => [updatedPost];
}
