import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/space_game/dto/invent_dto.dart';
import 'package:spacehero/presentation/space_game/dto/statistic_dto.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

part 'space_game_event.dart';

part 'space_game_state.dart';

enum GameStatus {
  initial, // new game screen
  respawn, // player positioned & start game with 5 sec damage pause
  respawned, // damage is active
  gameOver, // game result screen
  statistics, // statistics screen
}

class SpaceGameBloc extends Bloc<SpaceGameEvent, SpaceGameState> {
  StatisticDto statistic = const StatisticDto.initial();
  InventDto invent = const InventDto.initial();
  GameStatus gameStatus = GameStatus.initial;

  SpaceGameBloc() : super(const SpaceGameInitialState()) {
    on<ScoreAddEvent>(_gameLoopAddScore);
    on<PlayerDiedEvent>(_gameLoopPlayerDied);
    on<PlayerFireEvent>(_gameLoopPlayerFire);
    on<GameLoadedEvent>(_gameLoopGameLoaded);
  }

  FutureOr<void> _gameLoopGameLoaded(
    final GameLoadedEvent event,
    final Emitter<SpaceGameState> emit,
  ) async {
    await respawnPlayer(emit);
  }

  FutureOr<void> _gameLoopPlayerDied(
    final PlayerDiedEvent event,
    final Emitter<SpaceGameState> emit,
  ) async {
    statistic = statistic.copyWith(brokenLives: statistic.brokenLives + 1);
    emit(StatisticChangedState(statistic: statistic));
    await respawnPlayer(emit);
  }

  FutureOr<void> respawnPlayer(Emitter emit) async {
    gameStatus = GameStatus.respawn;
    emit(const SpaceGameStatusChanged(status: GameStatus.respawn));
    await Future.delayed(
      const Duration(seconds: AppConstants.playerRespawnTime),
      () {
        if (gameStatus == GameStatus.respawn) {
          gameStatus = GameStatus.respawned;
          emit(const SpaceGameStatusChanged(status: GameStatus.respawned));
        }
      },
    );
  }

  FutureOr<void> _gameLoopPlayerFire(
    final PlayerFireEvent event,
    final Emitter<SpaceGameState> emit,
  ) {
    int rocketCount = invent.rocket - 1;
    if (rocketCount >= 0) {
      invent = invent.copyWith(rocket: rocketCount);
      emit(PlayerFireState(rocketCount));
      emit(InventChangedState(invent: invent));
    } else {
      rocketCount = 0;
    }
  }

  FutureOr<void> _gameLoopAddScore(
    final ScoreAddEvent event,
    final Emitter<SpaceGameState> emit,
  ) {
    statistic = statistic.copyWith(score: statistic.score + event.scoreDelta);
    emit(StatisticChangedState(statistic: statistic));
  }
}
