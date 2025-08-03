

import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/di/barril_dependencias.dart';

class DeleteAllUserCase {

  final UserRepository userRepository;

  DeleteAllUserCase({required this.userRepository});

  Future<Either<Failure, bool>> call() {
    return userRepository.deleteAllUsers();
  }

}