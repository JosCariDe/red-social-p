
import 'package:red_social_prueba/features/post/data/data_sources/local/post_local_data_source.dart';
import 'package:red_social_prueba/features/post/data/models/post_model.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart';
import 'dart:async';

class PostSqliteDataSourceImpl implements PostLocalDataSource{
  @override
  Future<List<PostModel>> getAllPostLocal() {
    throw UnimplementedError();
  }

  @override
  Future<bool> savePostInLocal(Post post) {
    throw UnimplementedError();
  }
}