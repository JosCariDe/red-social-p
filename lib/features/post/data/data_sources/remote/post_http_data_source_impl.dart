import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:red_social_prueba/features/post/data/models/post_model.dart';

class PostHttpDataSourceImpl implements PostRemoteDataSource {
  final String baseUrl = 'https://dummyjson.com/posts';

  @override
  Future<List<PostModel>> getAllPostRemote({int limit = 10, int skip = 0}) async {
    try {
      final response = await http.get(
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
  Future<PostModel> getPostRemoteById(int idPost) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/$idPost'));

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
  
  @override
  Future<int> getCountPostRemote() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl?limit=1'));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
                            // ? A hoy 18/07/2025: "total": 251
        final int postCount = jsonData['total'];

        return postCount;
      } else {
        throw ServerFailure();
      }
    } catch (e) {
      throw ServerFailure();
    }
  }
}
