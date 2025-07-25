import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Post extends Equatable {
  final int id;
  final String title;
  final String body;
  final List<String> tags;
  final Reactions reactions;
  final int views;
  final int userId;
  String reactionUser;

  Post({
    required this.id,
    required this.title,
    required this.body,
    required this.tags,
    required this.reactions,
    required this.views,
    required this.userId,
    this.reactionUser = '',
  });

  @override
  List<Object?> get props =>
      [id, title, body, tags, reactions, views, userId, reactionUser];
}

class Reactions {
  int likes;
  int dislikes;

  Reactions({
    required this.likes,     
    required this.dislikes,  
  });
}
