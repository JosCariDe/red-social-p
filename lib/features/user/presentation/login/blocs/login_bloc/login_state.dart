part of 'login_bloc.dart';

sealed class LoginState extends Equatable {
  const LoginState();
  
  @override
  List<Object?> get props => [];
}

final class LoginInitial extends LoginState {}

final class LoginLoading extends LoginState {}

final class LoginSuccess extends LoginState {
  final int userId;
  final String username;

  const LoginSuccess({required this.userId, required this.username});

  @override
  List<Object?> get props => [userId, username];

}

class LoginFailure extends LoginState {
  final String message;

  const LoginFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
