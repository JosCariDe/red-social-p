
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';
import 'package:red_social_prueba/features/user/domain/repositories/user_repository.dart';

class GetUserUseCase {

  final UserRepository userRepository;

  GetUserUseCase({required this.userRepository});

  Future<Either<Failure, User>> call(int id) async{
    return userRepository.getUser(id);
  }

}