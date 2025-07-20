import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';

class UpdateReactionPostUseCase {
  final PostRepository repository;

  UpdateReactionPostUseCase(this.repository);

  Future<Either<Failure, bool>> call(int idPost, {String reactionUser = ''}) {
    return repository.updateReactionPost(idPost, reactionUser: reactionUser);
  }
}
