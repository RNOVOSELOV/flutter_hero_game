part of 'space_game_bloc.dart';

abstract class SpaceGameEvent extends Equatable {
  const SpaceGameEvent();
}

class ScoreAddEvent extends SpaceGameEvent {
  final int scoreDelta;

  const ScoreAddEvent({required this.scoreDelta});

  @override
  List<Object?> get props => [scoreDelta];
}

class PlayerFireEvent extends SpaceGameEvent {

  @override
  List<Object?> get props => [];

}

class PlayerDiedEvent extends SpaceGameEvent {
  const PlayerDiedEvent();

  @override
  List<Object?> get props => [];
}

class PlayerRespawnedEvent extends SpaceGameEvent {
  const PlayerRespawnedEvent();

  @override
  List<Object?> get props => [];
}
