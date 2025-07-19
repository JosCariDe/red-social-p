
import 'package:red_social_prueba/features/post/data/models/post_model.dart';
abstract class PostRemoteDataSource {
  Future<PostModel> getPostRemoteById(int idPost);
  Future<List<PostModel>> getAllPostRemote({int limit = 10, int skip = 0});
  Future<int> getCountPostRemote();
}
