import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';
import 'package:red_social_prueba/features/user/domain/uses_cases/get_all_user_use_case.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  final GetAllUserUseCase getAllUserUseCase;
  AuthUserBloc({required this.getAllUserUseCase}) : super(AuthUserInitial()) {
    on<AuthUserLoggedIn>((event, emit) {
      emit(AuthUserAuthenticated(user: event.user));
    });
    on<AuthUserLoggedOut>((event, emit) {
      emit(AuthUserUnauthenticated());
    });
    on<VerifiedUserLogging>((event, emit) async{
      final currentSate = state;
      debugPrint('Entrando al bloccccccccc');
      
      final responseUseCase = await getAllUserUseCase();

      responseUseCase.fold( (failure) {
        debugPrint('Error al intentar verificar la sesion desde el bloc Auth con Use Case');
        emit(AuthUserError(message:'Error al intentar verificar la sesion desde el bloc Auth con Use Case' ));
      }, (userList) {
        if (userList.isEmpty){
          debugPrint('Lista es vacia de Users');
          emit(AuthUserInitial());
        }else {
          if (userList.length > 1) {
            debugPrint('Lista Llena de Users');
            emit(AuthUserError(message: 'Por alguna razon en el sharedPreference hay mas de un user'));
          }else {
            debugPrint('Lista con un solo user');
            emit(AuthUserAuthenticated(user: userList[0]));
          }
        }
      });

      if (state is AuthUserAuthenticated) return;



      
    });
  }
}
