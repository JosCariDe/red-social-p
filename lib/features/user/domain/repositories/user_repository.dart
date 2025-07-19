
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';

abstract class UserRepository {

  Future<Either<Failure, User>> saveUser(String email, String password);
  Future<Either<Failure, User>> deleteUser(int id);

} 