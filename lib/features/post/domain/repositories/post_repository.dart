import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart'; // Post es compartido entre Post y User

abstract class PostRepository {

  Future<Either<Failure, Post>> getOnePost(int id);
  Future<Either<Failure, List<Post>>> getAllPost();
  Future<Either<Failure, int>> getCountPosts();
  Future<Either<Failure, List<Post>>> getAllPostsByIdUser();

}