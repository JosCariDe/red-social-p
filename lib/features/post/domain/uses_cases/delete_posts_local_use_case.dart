import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/config/exports/exports_data.dart';
import 'package:red_social_prueba/core/errors/failure.dart';

class DeletePostsLocalUseCase {
  final PostRepository postRepository;

  DeletePostsLocalUseCase({required this.postRepository});

  Future<Either<Failure, void>> call() {
    return postRepository.clearLocalPosts();
  }
}
