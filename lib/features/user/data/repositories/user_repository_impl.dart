import 'dart:io';
import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:red_social_prueba/core/errors/failure.dart';
import 'package:red_social_prueba/features/user/data/data_sources/local/user_local_data_source.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';
import 'package:red_social_prueba/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl({required this.userLocalDataSource});

  //TODO Función privada para manejar errores y maneja si devolver Right(result) o Left(Error)
  Future<Either<Failure, T>> _handleRequest<T>(
    Future<T> Function() request,
  ) async {
    try {
      final result = await request();
      return Right(result);
    } on HttpException catch (error) {
      debugPrint('Error HTTP remoto: $error');
      return Left(ServerFailure());
    } on LocalFailure catch (error) {
      debugPrint('Error local DB: $error');
      return Left(LocalFailure());
    } catch (error) {
      debugPrint('Error inesperado: $error');
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, bool>> deleteUser(int id) {
    return _handleRequest(() async {
      return userLocalDataSource.deleteUserLocal(id);
    });
  }

  @override
  Future<Either<Failure, User>> getUser(int id) {
    return _handleRequest(() async {
      return userLocalDataSource.getUserLocal(id);
    });
  }

  @override
  Future<Either<Failure, bool>> saveUser(String email, String password) {
    return _handleRequest(() async {
      final random = Random();
      final id = random.nextInt(9000) + 1000; //1000 al 9999
      return userLocalDataSource.saveUserLocal(
        User(id: id, email: email, password: password),
      );
    });
  }
}
