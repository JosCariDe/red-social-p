part of 'create_post_bloc.dart';

sealed class CreatePostEvent extends Equatable {
  const CreatePostEvent();

  @override
  List<Object> get props => [];
}

class CreatePostSubmitted extends CreatePostEvent {
  final String title;
  final String body;
  final List<String> tags;

  const CreatePostSubmitted({
    required this.title,
    required this.body,
    required this.tags,
  });

  @override
  List<Object> get props => [title, body, tags];
}
