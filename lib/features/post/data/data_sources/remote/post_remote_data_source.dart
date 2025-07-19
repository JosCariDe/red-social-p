
import 'package:red_social_prueba/features/post/data/models/post_model.dart';
abstract class PostRemoteDataSource {

  Future<PostModel> getPostRemoteById(int idPost);
  Future<List<PostModel>> getAllPostRemote();
  Future<int> getCountPostRemote();

}