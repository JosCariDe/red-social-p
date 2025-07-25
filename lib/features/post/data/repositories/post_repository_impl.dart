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
  Future<Either<Failure, List<Post>>> getAllPost({
    int limit = 10,
    int skip = 0,
  }) {
    return _handleRequest(() async {
      List<Post> localPosts = [];
      if (skip == 0) {
        localPosts = await postLocalDataSource.getAllPostLocal();
      }

      final remotePosts = await postRemoteDataSource.getAllPostRemote(
        limit: limit,
        skip: skip,
      );

      final localPostIds = localPosts.map((post) => post.id).toSet();

      final uniqueRemotePosts = remotePosts
          .where((remotePost) => !localPostIds.contains(remotePost.id))
          .toList();

      final mergedPosts = [...localPosts, ...uniqueRemotePosts];

      mergedPosts.sort((a, b) => b.id.compareTo(a.id));
      mergedPosts.forEach((post) => debugPrint('${post.id.toString()}\n'));

      return mergedPosts;
    });
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPostsByIdUserLocal(int idUser) {
    return _handleRequest(() async {
      final res = await postLocalDataSource.getAllPostsLocalByIdUser(idUser);
      for (var postLocal in res) {
        debugPrint('Post Local con el id: ${postLocal.id}');
      }
      return res;
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
      final isLocal = await searchPostLocalByID(idPost);
      if (idPost > count || isLocal.getOrElse(() => false)) {
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
  Future<Either<Failure, Post>> updateReactionPost(
    int idPost, {
    String reactionUser = '',
  }) {
    return _handleRequest(() async {
      //? El search va a retonar un false o true, nunca un error, ya que se captura con un try
      final isLocal = await searchPostLocalByID(idPost);

      PostModel post;
      //? Aquí verificamos si está localmente o si se tiene que guardar localmente
      if (isLocal.getOrElse(() => false)) {
        post = await postLocalDataSource.getOnePostLocalById(idPost);
      } else {
        final remotePost = await postRemoteDataSource.getPostRemoteById(idPost);
        await postLocalDataSource.savePostLocal(remotePost);
        post = await postLocalDataSource.getOnePostLocalById(idPost);
      }
      debugPrint(
        'El post tiene: likes: ${post.reactions.likes}, dislikes: ${post.reactions.dislikes}',
      );

      //? Empieza lógica para editar el db Local.
      final currentReaction = post.reactionUser;
      debugPrint(
        'Reaccion actual del user: ${reactionUser}, reaccion en el DB: ${currentReaction} ',
      );
      if (reactionUser == currentReaction) {
        // User is toggling off their reaction
        if (reactionUser == 'like') {
          post.reactions.likes--;
        } else if (reactionUser == 'dislike') {
          post.reactions.dislikes--;
        }
        post.reactionUser = '';
      } else {
        // User is changing their reaction or reacting for the first time
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
      final Post postUpdated = await postLocalDataSource.getOnePostLocalById(
        idPost,
      );
      debugPrint(
        'El post tiene: likes: ${postUpdated.reactions.likes}, dislikes: ${postUpdated.reactions.dislikes}, reactionUser In Db: ${postUpdated.reactionUser}\n',
      );
      final List<Post> getPostLocales = await postLocalDataSource
          .getAllPostLocal();
      getPostLocales.forEach(
        (postLocal) =>
            debugPrint('\nPost Local con id: ${postLocal.id.toString()}'),
      );
      return postUpdated;
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

  @override
  Future<Either<Failure, void>> clearLocalPosts() {
    return _handleRequest(() async {
      await postLocalDataSource.clearAllPostsLocal();
    });
  }
}
