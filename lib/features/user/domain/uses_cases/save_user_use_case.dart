
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/user/domain/repositories/user_repository.dart';

class SaveUserUseCase {

  final UserRepository userRepository;

  SaveUserUseCase({required this.userRepository});

  Future<Either<Failure, bool>> call(String email, String password) async{
    return userRepository.saveUser(email, password);
  }

}