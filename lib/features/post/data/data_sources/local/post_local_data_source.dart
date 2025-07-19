import 'package:red_social_prueba/features/post/data/models/post_model.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart';

abstract class PostLocalDataSource {
  Future<bool> savePostInLocal(Post post);
  Future<List<PostModel>> getAllPostLocal();
  
}