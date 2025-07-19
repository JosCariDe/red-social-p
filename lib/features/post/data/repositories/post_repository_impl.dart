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

  @override
  Future<Either<Failure, List<Post>>> getAllPost() async {
    try {
      final List<Post> localPosts = await postLocalDataSource.getAllPostLocal();
      final List<Post> remotePosts = await postRemoteDataSource
          .getAllPostRemote();

      final allPosts = [...localPosts, ...remotePosts];
      return Right(allPosts); //? Lado Derecho es que salió bien los llamados
    } on HttpException catch (error) {
      //? Error en el remoto DataSource
      debugPrint('Error HTTP remoto: ${error.toString()}');
      return Left(ServerFailure());
    } on LocalFailure catch (error) {
      //? Error en el Local DataSource
      debugPrint('Error local DB: ${error.toString()}');
      return Left(LocalFailure());
    } catch (error) {
      //? Cualquier otro error
      debugPrint('Error inesperado en el repositorio: ${error.toString()}');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPostsByIdUserLocal(int idUser) async {
    try {
      final List<Post> localPosts = await postLocalDataSource.getAllPostsLocalByIdUser(idUser);
  

      final allPosts = [...localPosts];
      return Right(allPosts); //? Lado Derecho es que salió bien los llamados
    } on HttpException catch (error) {
      //? Error en el remoto DataSource
      debugPrint('Error HTTP remoto: ${error.toString()}');
      return Left(ServerFailure());
    } on LocalFailure catch (error) {
      //? Error en el Local DataSource
      debugPrint('Error local DB: ${error.toString()}');
      return Left(LocalFailure());
    } catch (error) {
      //? Cualquier otro error
      debugPrint('Error inesperado en el repositorio: ${error.toString()}');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, int>> getCountPosts() async {
    try {
      final int counPosts = await postRemoteDataSource.getCountPostRemote();
  

      return Right(counPosts); //? Lado Derecho es que salió bien los llamados
    } on HttpException catch (error) {
      //? Error en el remoto DataSource
      debugPrint('Error HTTP remoto: ${error.toString()}');
      return Left(ServerFailure());
    } on LocalFailure catch (error) {
      //? Error en el Local DataSource
      debugPrint('Error local DB: ${error.toString()}');
      return Left(LocalFailure());
    } catch (error) {
      //? Cualquier otro error
      debugPrint('Error inesperado en el repositorio: ${error.toString()}');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Post>> getOnePostById(int idPost)async {
    try {
      final Post post;
      //? Si el id es mayor al count de Posts del remote, entonces hace la busqueda en el local
      if (idPost > await postRemoteDataSource.getCountPostRemote()){
        post = await postLocalDataSource.getOnePostLocalById(idPost);
      }else {
        post = await postRemoteDataSource.getPostRemoteById(idPost);
      }
  
      return Right(post); //? Lado Derecho es que salió bien los llamados

    } on HttpException catch (error) {
      //? Error en el remoto DataSource
      debugPrint('Error HTTP remoto: ${error.toString()}');
      return Left(ServerFailure());
    } on LocalFailure catch (error) {
      //? Error en el Local DataSource
      debugPrint('Error local DB: ${error.toString()}');
      return Left(LocalFailure());
    } catch (error) {
      //? Cualquier otro error
      debugPrint('Error inesperado en el repositorio: ${error.toString()}');
      return Left(ServerFailure());
    }
  }
  

}
