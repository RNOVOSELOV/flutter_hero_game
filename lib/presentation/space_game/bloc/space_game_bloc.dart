import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'space_game_event.dart';

part 'space_game_state.dart';

class SpaceGameBloc extends Bloc<SpaceGameEvent, SpaceGameState> {
  SpaceGameBloc() : super(SpaceGameInitial()) {
    on<SpaceGameEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
