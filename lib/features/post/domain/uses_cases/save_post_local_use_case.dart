
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/domain/entities/post.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';

class SavePostLocalUseCase {
  final PostRepository postRepository;

  SavePostLocalUseCase({required this.postRepository});

  Future<Either<Failure, bool>> call(Post post) {
    return postRepository.savePostLocal(post);
  }
}