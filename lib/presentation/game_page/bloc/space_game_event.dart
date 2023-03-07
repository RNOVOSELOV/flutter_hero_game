part of 'space_game_bloc.dart';

abstract class SpaceGameEvent extends Equatable {
  const SpaceGameEvent();
}

class GameLoadedEvent extends SpaceGameEvent {
  @override
  List<Object?> get props => [];
}

class OpenInitialScreenEvent extends SpaceGameEvent {
  @override
  List<Object?> get props => [];
}

class PlayerDiedEvent extends SpaceGameEvent {
  const PlayerDiedEvent();

  @override
  List<Object?> get props => [];
}

class ScoreAddEvent extends SpaceGameEvent {
  final int scoreDelta;

  const ScoreAddEvent({required this.scoreDelta});

  @override
  List<Object?> get props => [scoreDelta];
}

/////// BELOW NOT CHECKED

class PlayerFireEvent extends SpaceGameEvent {
  @override
  List<Object?> get props => [];
}
