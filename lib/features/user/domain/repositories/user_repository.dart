
import 'package:dartz/dartz.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';

abstract class UserRepository {

  Future<Either<Failure, bool>> saveUser(String email, String password);
  Future<Either<Failure, bool>> deleteUser(int id);
  Future<Either<Failure, User>> getUser(int id);

} 