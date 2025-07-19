import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';

class GetCountPostUseCase {
  final PostRepository postRepository;

  GetCountPostUseCase({required this.postRepository});

  Future<Either<Failure, int>> call() {
    return postRepository.getCountPosts();
  }
}
