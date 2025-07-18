import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/publicacion/domain/entities/post.dart';

abstract class PostRepository {

  Future<Either<Failure, Post>> getOnePost(int id);
  Future<Either<Failure, List<Post>>> getAllPost();
  

}