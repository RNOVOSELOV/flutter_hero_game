part of 'space_game_bloc.dart';

abstract class SpaceGameState extends Equatable {
  const SpaceGameState();
}

class SpaceGameInitial extends SpaceGameState {
  @override
  List<Object> get props => [];
}
