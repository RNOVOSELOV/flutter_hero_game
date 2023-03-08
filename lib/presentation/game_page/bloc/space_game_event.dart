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

class OpenStatisticScreenEvent extends SpaceGameEvent {
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

class PlayerFireEvent extends SpaceGameEvent {
  @override
  List<Object?> get props => [];
}

class BonusArmorEvent extends SpaceGameEvent {
  const BonusArmorEvent();

  @override
  List<Object?> get props => [];
}

class PlayerArmorEvent extends SpaceGameEvent {
  @override
  List<Object?> get props => [];
}

class BonusBombEvent extends SpaceGameEvent {
  const BonusBombEvent();

  @override
  List<Object?> get props => [];
}

class BonusHpEvent extends SpaceGameEvent {
  const BonusHpEvent();

  @override
  List<Object?> get props => [];
}

class BonusRocketEvent extends SpaceGameEvent {
  const BonusRocketEvent();

  @override
  List<Object?> get props => [];
}

class BonusMultiRocketEvent extends SpaceGameEvent {
  const BonusMultiRocketEvent();

  @override
  List<Object?> get props => [];
}

class BonusSpeedEvent extends SpaceGameEvent {
  const BonusSpeedEvent();

  @override
  List<Object?> get props => [];
}
