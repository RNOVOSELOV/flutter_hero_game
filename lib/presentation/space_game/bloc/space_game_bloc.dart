import 'dart:async';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spacehero/presentation/space_game/dto/invent_dto.dart';
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
  final gameStatusSubject =
      BehaviorSubject<GameStatus>.seeded(GameStatus.initial);

  final inventInfoSubject =
      BehaviorSubject<InventDto>.seeded(const InventDto.initial());

  Stream<GameStatus> observeGameStatus() => gameStatusSubject;

  Stream<InventDto> observeInvent() => inventInfoSubject;

  int lives = 0;

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
    lives++;
    await respawnPlayer(emit);
  }

  FutureOr<void> respawnPlayer(Emitter emit) async {
    gameStatusSubject.add(GameStatus.respawn);
    emit(const SpaceGameStatusChanged(status: GameStatus.respawn));
    await Future.delayed(
      const Duration(seconds: AppConstants.playerRespawnTime),
      () {
        if (gameStatusSubject.value == GameStatus.respawn) {
          gameStatusSubject.add(GameStatus.respawned);
          emit(const SpaceGameStatusChanged(status: GameStatus.respawned));
        }
      },
    );
  }

  /// BELOW NOT CHECKED

  FutureOr<void> _gameLoopAddScore(
    final ScoreAddEvent event,
    final Emitter<SpaceGameState> emit,
  ) {}

  FutureOr<void> _gameLoopPlayerFire(
    final PlayerFireEvent event,
    final Emitter<SpaceGameState> emit,
  ) {
    final inventValues = inventInfoSubject.value;
    int rocketCount = inventValues.rocket - 1;
    if (rocketCount >= 0) {
      emit(PlayerFireState(rocketCount));
      inventInfoSubject.add(inventValues.copyWith(rocket: rocketCount));
    } else {
      rocketCount = 0;
    }
  }

  @override
  Future<void> close() {
    inventInfoSubject.close();
    return super.close();
  }
}
