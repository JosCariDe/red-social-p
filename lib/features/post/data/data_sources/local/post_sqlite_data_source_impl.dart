import 'package:flutter/material.dart';
import 'package:red_social_prueba/core/db/local/posts_database.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/data/data_sources/local/post_local_data_source.dart';
import 'package:red_social_prueba/features/post/data/models/post_model.dart';
import 'dart:async';

import 'package:red_social_prueba/features/post/domain/entities/post.dart';

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
  Future<bool> savePostLocal(Post post) async {
    try {
      final postModel = PostModel.fromEntity(post);
      final db = await database.database;
      await db.insert('posts', postModel.toMap());
      return true;
    } catch (error) {
      throw LocalFailure();
    }
  }

  @override
  Future<List<PostModel>> getAllPostsLocalByIdUser(int userId) async {
    try {
      final db = await database.database;

      final result = await db.query(
        'posts',
        where: 'userId = ?',
        whereArgs: [userId],
      );

      return result.map((e) => PostModel.fromMap(e)).toList();
    } catch (error) {
      debugPrint('Error al obtener posts por userId localmente: $error');
      throw LocalFailure();
    }
  }

  @override
  Future<PostModel> getOnePostLocalById(int idPost) async {
    try {
      final db = await database.database;

      final result = await db.query(
        'posts',
        where: 'id = ?',
        whereArgs: [idPost],
      );

      if (result.isNotEmpty) {
        return PostModel.fromMap(result.first);
      } else {
        throw LocalFailure(); // Error personalizado
      }
    } catch (error) {
      debugPrint('Error al obtener post por ID localmente: $error');
      throw LocalFailure();
    }
  }

  @override
  Future<void> updatePostLocal(PostModel post) async {
    try {
      final db = await database.database;
      await db.update(
        'posts',
        post.toMap(),
        where: 'id = ?',
        whereArgs: [post.id],
      );
    } catch (error) {
      debugPrint('Error al actualizar post localmente: $error');
      throw LocalFailure();
    }
  }

  @override
  Future<void> clearAllPostsLocal() async {
    final db = database; 
    await db.clearAllPosts();
  }
}
