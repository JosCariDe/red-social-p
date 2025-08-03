
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/di/barril_dependencias.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';

class GetAllUserUseCase {

  final UserRepository userRepository;

  GetAllUserUseCase({required this.userRepository});

  Future<Either<Failure, List<User>>> call(){
    return userRepository.getAllUser();
  }

}