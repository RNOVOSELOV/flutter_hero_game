part of 'space_game_bloc.dart';

abstract class SpaceGameState extends Equatable {
  const SpaceGameState();
}

// Game states
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

class InventChangedState extends SpaceGameState {
  final InventDto invent;

  const InventChangedState({required this.invent});

  @override
  List<Object?> get props => [invent];
}

class StatisticChangedState extends SpaceGameState {
  final StatisticDto statistic;

  const StatisticChangedState({required this.statistic});

  @override
  List<Object?> get props => [];
}

// Game loop states
class SpaceGameScoreState extends SpaceGameState {
  final int score;

  const SpaceGameScoreState({required this.score});

  @override
  List<Object?> get props => [score];
}

// Player states
class PlayerFireState extends SpaceGameState {
  final int count;

  const PlayerFireState(this.count);

  @override
  List<Object?> get props => [count];
}
