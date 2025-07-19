import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart';

class PostRepositoryImpl implements PostRepository {
  @override
  Future<Either<Failure, List<Post>>> getAllPost() {
    
    throw UnimplementedError();
  }

  @override
  Future<Either<Failure, List<Post>>> getAllPostsByIdUser() {
    throw UnimplementedError();
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