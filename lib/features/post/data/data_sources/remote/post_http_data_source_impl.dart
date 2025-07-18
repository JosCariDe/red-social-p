import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:red_social_prueba/features/post/data/models/post_model.dart';

class PostHttpDataSourceImpl implements PostRemoteDataSource {
  final http.Client client;

  PostHttpDataSourceImpl({required this.client});

  final String baseUrl = 'https://dummyjson.com/posts';

  @override
  Future<List<PostModel>> getAllPost({int limit = 10, int skip = 0}) async {
    try {
      final response = await client.get(
        Uri.parse('$baseUrl?limit=$limit&skip=$skip'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List posts = jsonData['posts'];

        return posts.map((postJson) => PostModel.fromJson(postJson)).toList();
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }

  @override
  Future<PostModel> getPost(int id) async {
    try {
      final response = await client.get(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return PostModel.fromJson(jsonData);
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}
