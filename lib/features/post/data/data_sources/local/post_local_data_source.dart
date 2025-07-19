import 'package:red_social_prueba/features/post/data/models/post_model.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

abstract class PostLocalDataSource {
  Future<bool> savePostLocal(Post post);
  Future<List<PostModel>> getAllPostLocal();
  Future<List<PostModel>> getAllPostsLocalByIdUser(int userId);
  Future<PostModel> getOnePostLocalById(int idPost);
  
}