
import 'package:red_social_prueba/features/post/data/models/post_model.dart';

abstract class PostRemoteDataSource {

  Future<PostModel> getPost(int id);
  Future<List<PostModel>> getAllPost();
  Future<int> getCountPostRemote();

}