import 'dart:convert';

import 'package:red_social_prueba/features/post/data/models/reactions_model.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

class PostModel extends Post {

  String reactionUser;

  PostModel({
    required super.id,
    required super.title,
    required super.body,
    required super.tags,
    required super.reactions,
    required super.views,
    required super.userId,
    this.reactionUser = '',
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

  /// Para guardar en SQLite
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'tags': jsonEncode(tags), // Convertimos lista a JSON string
      'likes': reactions.likes,
      'dislikes': reactions.dislikes,
      'views': views,
      'userId': userId,
      'reactionUser': reactionUser
    };
  }

  /// Para leer desde SQLite
  factory PostModel.fromMap(Map<String, dynamic> map) {
    return PostModel(
      id: map['id'],
      title: map['title'],
      body: map['body'],
      tags: List<String>.from(jsonDecode(map['tags'])),
      reactions: ReactionsModel(
        likes: map['likes'],
        dislikes: map['dislikes'],
      ),
      views: map['views'],
      userId: map['userId'],
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
          : ReactionsModel(
              likes: entity.reactions.likes,
              dislikes: entity.reactions.dislikes,
            ),
      views: entity.views,
      userId: entity.userId,
    );
  }
}
