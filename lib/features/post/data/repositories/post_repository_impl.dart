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
    final List<Post> remotePosts = await postRemoteDataSource.getAllPostRemote();
    
    final allPosts = [...localPosts, ...remotePosts];
    return Right(allPosts); //? Lado Derecho es que salió bien los llamados
    
  } on HttpException catch (error) { //? Error en el remoto DataSource
    debugPrint('Error HTTP remoto: ${error.toString()}');
    return Left(ServerFailure());
    
  } on LocalFailure catch (error) { //? Error en el Local DataSource
    debugPrint('Error local DB: ${error.toString()}');
    return Left(LocalFailure());

  } catch (error) { //? Cualquier otro error
    debugPrint('Error inesperado en el repositorio: ${error.toString()}');
    return Left(ServerFailure()); 
  }
}

  @override
  Future<Either<Failure, List<Post>>> getAllPostsByIdUser()async {
    try {
    final List<Post> localPosts = await postLocalDataSource.getAllPostLocal();
    final List<Post> remotePosts = await postRemoteDataSource.getAllPostRemote();
    
    final allPosts = [...localPosts, ...remotePosts];
    return Right(allPosts); //? Lado Derecho es que salió bien los llamados
    
  } on HttpException catch (error) { //? Error en el remoto DataSource
    debugPrint('Error HTTP remoto: ${error.toString()}');
    return Left(ServerFailure());
    
  } on LocalFailure catch (error) { //? Error en el Local DataSource
    debugPrint('Error local DB: ${error.toString()}');
    return Left(LocalFailure());

  } catch (error) { //? Cualquier otro error
    debugPrint('Error inesperado en el repositorio: ${error.toString()}');
    return Left(ServerFailure()); 
  }
  }

  @override
  Future<Either<Failure, int>> getCountPosts() {
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, Post>> getOnePost(int id) {
    throw UnimplementedError();
  }
}
