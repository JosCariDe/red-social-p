import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/user/domain/uses_cases/save_user_use_case.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final SaveUserUseCase saveUserUseCase;

  LoginBloc({required this.saveUserUseCase}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
    LoginSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(LoginLoading());
    final result = await saveUserUseCase(event.email, event.password);
    result.fold(
      (failure) => emit(LoginFailure(message: 'Error al iniciar sesión')),
      (success) {
        // Simula obtener el id y nombre del usuario (ajusta según tu modelo real)
        emit(LoginSuccess(userId: 777, username: event.email));
      },
    );
  }
}
