
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/user/domain/repositories/user_repository.dart';

class DeleteUserCase {

  final UserRepository userRepository;

  DeleteUserCase({required this.userRepository});

  Future<Either<Failure, bool>> call(int id) async{
    return userRepository.deleteUser(id);
  }

}