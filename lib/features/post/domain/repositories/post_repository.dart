import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';

abstract class PostRepository {

  Future<Either<Failure, Post>> getOnePostById(int idPost);
  Future<Either<Failure, List<Post>>> getAllPost({int limit = 10, int skip = 0});
  Future<Either<Failure, int>> getCountPosts();
  Future<Either<Failure, List<Post>>> getAllPostsByIdUserLocal(int idUser);
  Future<Either<Failure, bool>> savePostLocal(Post post);


}