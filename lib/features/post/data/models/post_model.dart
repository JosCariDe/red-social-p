import 'package:red_social_prueba/features/post/data/models/reactions_model.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart';

class PostModel extends Post {
  PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.tags,
    required super.reactions,
    required super.views,
    required super.userId,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'], 
      body: json['body'],
      tags: List<String>.from(json['tags']),
      reactions: ReactionsModel.fromJson(json['reactions']),
      views: json['views'],
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'tags': tags,
      'reactions': (reactions as ReactionsModel).toJson(), 
      'views': views,
      'userId': userId,
    };
  }

  factory PostModel.fromEntity(Post entity) {
    return PostModel(
      id: entity.id,
      title: entity.title,
      body: entity.body,
      tags: entity.tags,
      reactions: entity.reactions is ReactionsModel 
                   ? entity.reactions 
                   : ReactionsModel(likes: entity.reactions.likes, dislikes: entity.reactions.dislikes),
      views: entity.views,
      userId: entity.userId,
    );
  }
}