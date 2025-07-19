
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';
import 'package:red_social_prueba/shared/domain/entities/post.dart';

class GetAllPostByIdUserLocalUseCase {

  final PostRepository postRepository;

  GetAllPostByIdUserLocalUseCase({required this.postRepository});

  Future<Either<Failure, List<Post>>> call(int idUser) {
    return postRepository.getAllPostsByIdUserLocal(idUser);
  }

}