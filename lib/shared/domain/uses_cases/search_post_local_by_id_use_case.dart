import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/post/domain/repositories/post_repository.dart';

class SearchPostLocalByIdUseCase {
  final PostRepository repository;

  SearchPostLocalByIdUseCase(this.repository);

  Future<Either<Failure, bool>> call(int idPost) {
    return repository.searchPostLocalByID(idPost);
  }
}
