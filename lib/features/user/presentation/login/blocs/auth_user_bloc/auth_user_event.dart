part of 'auth_user_bloc.dart';

sealed class AuthUserEvent extends Equatable {
  const AuthUserEvent();

  @override
  List<Object?> get props => [];
}

class AuthUserLoggedIn extends AuthUserEvent{

  final User user;

  const AuthUserLoggedIn({required this.user});

  @override
  List<Object> get props => [];

}

class AuthUserLoggedOut extends AuthUserEvent {}
