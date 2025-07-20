import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/user/domain/entities/user.dart';

part 'auth_user_event.dart';
part 'auth_user_state.dart';

class AuthUserBloc extends Bloc<AuthUserEvent, AuthUserState> {
  AuthUserBloc() : super(AuthUserInitial()) {
    on<AuthUserLoggedIn>((event, emit) {
      emit(AuthUserAuthenticated(user: event.user));
    });
    on<AuthUserLoggedOut>((event, emit) {
      emit(AuthUserUnauthenticated());
    });
  }
}
