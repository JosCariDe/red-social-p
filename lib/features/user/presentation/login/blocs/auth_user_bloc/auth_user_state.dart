part of 'auth_user_bloc.dart';

sealed class AuthUserState extends Equatable {
  const AuthUserState();
  
  @override
  List<Object> get props => [];
}

final class AuthUserInitial extends AuthUserState {}
final class AuthUserLoading extends AuthUserState {}
final class AuthUserAuthenticated extends AuthUserState {

  final User user;

  const AuthUserAuthenticated({required this.user});

  @override
  List<Object> get props => [user];

}
final class AuthUserUnauthenticated extends AuthUserState {}
final class AuthUserError extends AuthUserState {
  final String message;

  const AuthUserError({required this.message});
  
  @override
  List<Object> get props => [message];
}
