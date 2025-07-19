
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

class ReactionsModel extends Reactions {
  ReactionsModel({
    required super.likes,
    required super.dislikes,
  });

  factory ReactionsModel.fromJson(Map<String, dynamic> json) {
    return ReactionsModel(
      likes: json['likes'],
      dislikes: json['dislikes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'dislikes': dislikes,
    };
  }
}