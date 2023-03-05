part of 'space_game_bloc.dart';

abstract class SpaceGameState extends Equatable {
  const SpaceGameState();
}

class SpaceGameInitialState extends SpaceGameState {
  const SpaceGameInitialState();

  @override
  List<Object> get props => [];
}

class SpaceGameStatusChanged extends SpaceGameState {
  final GameStatus status;

  const SpaceGameStatusChanged({required this.status});

  @override
  List<Object?> get props => [status];
}

class SpaceGameScoreState extends SpaceGameState {
  final int score;

  const SpaceGameScoreState({required this.score});

  @override
  List<Object?> get props => [score];
}
