import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'updated_reactions_post_event.dart';
part 'updated_reactions_post_state.dart';

class UpdatedReactionsPostBloc extends Bloc<UpdatedReactionsPostEvent, UpdatedReactionsPostState> {
  UpdatedReactionsPostBloc() : super(UpdatedReactionsPostInitial()) {
    on<UpdatedReactionsPostEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
