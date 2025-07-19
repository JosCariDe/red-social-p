import 'package:equatable/equatable.dart';

class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final Reactions reactions;
  final int views;
  final int userId;

  const Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
  });
  
  @override
  List<Object?> get props => [id, title, body, tags, reactions, views, userId];
}

class Reactions {
  int likes;
  int dislikes;

  Reactions({
    required this.likes,     
    required this.dislikes,  
  });
}