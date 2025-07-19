import 'package:red_social_prueba/core/db/local/posts_database.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/data/data_sources/local/post_local_data_source.dart';
import 'package:red_social_prueba/features/post/data/models/post_model.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart';
import 'dart:async';

class PostSqliteDataSourceImpl implements PostLocalDataSource {
  final PostsDatabase database;

  PostSqliteDataSourceImpl({required this.database});

  @override
  Future<List<PostModel>> getAllPostLocal() async {
    try {
      final db = await database.database;
      final result = await db.query('posts');

      return result.map((e) => PostModel.fromMap(e)).toList();
    } catch (error) {
      throw LocalFailure();
    }
  }

  @override
  Future<bool> savePostInLocal(Post post) async {
    try {
      final postModel = PostModel.fromEntity(post);
      final db = await database.database;
      await db.insert('posts', postModel.toMap());
      return true;
    } catch (error) {
      throw LocalFailure();
    }
  }
}
