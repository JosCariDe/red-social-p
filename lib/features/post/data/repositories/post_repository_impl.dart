import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/data/data_sources/local/post_local_data_source.dart';
import 'package:red_social_prueba/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:red_social_prueba/features/post/data/models/post_model.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource postLocalDataSource;
  final PostRemoteDataSource postRemoteDataSource;

  PostRepositoryImpl({
    required this.postLocalDataSource,
    required this.postRemoteDataSource,
  });

  //TODO Función privada para manejar errores y maneja si devolver Right(result) o Left(Error)
  Future<Either<Failure, T>> _handleRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result);
    } on HttpException catch (error) {
      debugPrint('Error HTTP remoto: $error');
      return Left(ServerFailure());
    } on LocalFailure catch (error) {
      debugPrint('Error local DB: $error');
      return Left(LocalFailure());
    } catch (error) {
      debugPrint('Error inesperado: $error');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPost({int limit = 10, int skip = 0}) {
    return _handleRequest(() async {
      final localPosts = await postLocalDataSource.getAllPostLocal();
      final remotePosts = await postRemoteDataSource.getAllPostRemote(limit: limit, skip: skip);

      //! Cuando se guarda un post de la api remota, entonces con esto aseguramos que no
      //! se repita el post al llamar este metodo del repositorio, quedará 

      //? Obtener IDs de posts locales
      final localPostIds = localPosts.map((post) => post.id).toSet();

      //? Filtrar posts remotos que no esten en locales
      final uniqueRemotePosts = remotePosts
          .where((remotePost) => !localPostIds.contains(remotePost.id))
          .toList();

      final mergedPosts = [...localPosts, ...uniqueRemotePosts];

      //? Ordenar de mayor a menor ID
      mergedPosts.sort((a, b) => b.id.compareTo(a.id));

      return mergedPosts;
    });
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPostsByIdUserLocal(int idUser) {
    return _handleRequest(() async {
      return await postLocalDataSource.getAllPostsLocalByIdUser(idUser);
    });
  }

  @override
  Future<Either<Failure, int>> getCountPosts() {
    return _handleRequest(() async {
      return await postRemoteDataSource.getCountPostRemote();
    });
  }

  @override
  Future<Either<Failure, Post>> getOnePostById(int idPost) {
    return _handleRequest(() async {
      final count = await postRemoteDataSource.getCountPostRemote();
      if (idPost > count) {
        return await postLocalDataSource.getOnePostLocalById(idPost);
      } else {
        return await postRemoteDataSource.getPostRemoteById(idPost);
      }
    });
  }

  @override
  Future<Either<Failure, bool>> savePostLocal(Post post) async {
    return _handleRequest(() async {
      //final count = await postRemoteDataSource.getCountPostRemote();
      return await postLocalDataSource.savePostLocal(post);
    });
  }
  
  @override
  Future<Either<Failure, bool>> updateReactionPost(int idPost,
      {String reactionUser = ''}) {
    return _handleRequest(() async {
      final PostModel post =
          await postLocalDataSource.getOnePostLocalById(idPost);
      final currentReaction = post.reactionUser;

      if (reactionUser == currentReaction) {
        //? El usuario desactiva su reacción
        if (reactionUser == 'like') {
          post.reactions.likes--;
        } else if (reactionUser == 'dislike') {
          post.reactions.dislikes--;
        }
        post.reactionUser = '';
      } else {
        //? El usuario cambia su reacción o reacciona por primera vez
        if (currentReaction == 'like') {
          post.reactions.likes--;
        } else if (currentReaction == 'dislike') {
          post.reactions.dislikes--;
        }

        if (reactionUser == 'like') {
          post.reactions.likes++;
          post.reactionUser = 'like';
        } else if (reactionUser == 'dislike') {
          post.reactions.dislikes++;
          post.reactionUser = 'dislike';
        }
      }

      await postLocalDataSource.updatePostLocal(post);
      return true;
    });
  }

  @override
  Future<Either<Failure, bool>> searchPostLocalByID(int idPost) {
    return _handleRequest(() async {
      try {
        await postLocalDataSource.getOnePostLocalById(idPost);
        return true;
      } catch (e) {
        return false;
      }
    });
  }
}
