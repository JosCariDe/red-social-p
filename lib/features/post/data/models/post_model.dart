import 'package:red_social_prueba/shared/domain/entities/post.dart';

class PostModel extends Post {
  ({
    required super.id,
    required super.title,
    required super.body,
    required super.tags,
    required super.reactions,
    required super.views,
    required super.userId,
  });
}
