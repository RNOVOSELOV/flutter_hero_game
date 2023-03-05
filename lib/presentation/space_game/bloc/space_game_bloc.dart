import 'dart:async';
import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  final Size screenSize;

  SpaceGameBloc({required this.screenSize})
      : super(const SpaceGameInitialState()) {
    on<ScoreAddEvent>(_gameLoopAddScore);
    on<PlayerDiedEvent>(_gameLoopPlayerDied);
    on<PlayerRespawnedEvent>(_gameLoopPlayerRespawned);
  }

  FutureOr<void> _gameLoopPlayerDied(
    final PlayerDiedEvent event,
    final Emitter<SpaceGameState> emit,
  ) {}

  FutureOr<void> _gameLoopAddScore(
    final ScoreAddEvent event,
    final Emitter<SpaceGameState> emit,
  ) {}

  FutureOr<void> _gameLoopPlayerRespawned(
    final PlayerRespawnedEvent event,
    final Emitter<SpaceGameState> emit,
  ) {}
}
