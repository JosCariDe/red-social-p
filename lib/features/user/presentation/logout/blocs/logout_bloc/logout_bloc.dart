import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:red_social_prueba/features/post/domain/uses_cases/delete_posts_local_use_case.dart';

part 'logout_event.dart';
part 'logout_state.dart';

class LogoutBloc extends Bloc<LogoutEvent, LogoutState> {
  final DeletePostsLocalUseCase deletePostsLocalUseCase;

  LogoutBloc({required this.deletePostsLocalUseCase}) : super(LogoutInitial()) {
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<LogoutState> emit,
  ) async {
    emit(LogoutLoading());
    await deletePostsLocalUseCase();
    emit(LogoutSuccess());
  }
}