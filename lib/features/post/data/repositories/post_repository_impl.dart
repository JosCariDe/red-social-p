import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/data/data_sources/local/post_local_data_source.dart';
import 'package:red_social_prueba/features/post/data/data_sources/remote/post_remote_data_source.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart';

class PostRepositoryImpl implements PostRepository {
  final PostLocalDataSource postLocalDataSource;
  final PostRemoteDataSource postRemoteDataSource;

  PostRepositoryImpl({
    required this.postLocalDataSource,
    required this.postRemoteDataSource,
  });

  //TODO Función privada para manejar errores y maneja si devolver Right(result) o Left(Error)
  Future<Either<Failure, T>> _handleRequest<T>(Future<T> Function() request) async {
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
  Future<Either<Failure, List<Post>>> getAllPost() {
    return _handleRequest(() async {
      final localPosts = await postLocalDataSource.getAllPostLocal();
      final remotePosts = await postRemoteDataSource.getAllPostRemote();
      return [...localPosts, ...remotePosts];
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
  Future<Either<Failure, bool>> savePostLocal(Post post) async{

    return _handleRequest(() async {
      //final count = await postRemoteDataSource.getCountPostRemote();
      return await postLocalDataSource.savePostLocal(post);
    });
  }
}

