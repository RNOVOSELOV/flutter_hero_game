import 'package:equatable/equatable.dart';
import 'package:spacehero/game_core/game_core_helpers/game_state.dart';

class GameInfo extends Equatable {
  final GameSceneType gsType;
  final bool gameIsStarted;
  final int score;

  const GameInfo(
      {required this.gsType, required this.gameIsStarted, required this.score});

  @override
  List<Object?> get props => [gsType, gameIsStarted, score];
}
