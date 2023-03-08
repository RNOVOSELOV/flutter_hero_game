import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/data/models/game_result.dart';
import 'package:spacehero/data/repositories/results_repository.dart';
import 'package:spacehero/presentation/game_page/dto/invent_dto.dart';
import 'package:spacehero/presentation/game_page/dto/statistic_dto.dart';
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

// TODO add isolate loop
class SpaceGameBloc extends Bloc<SpaceGameEvent, SpaceGameState> {
  StatisticDto statistic = const StatisticDto.initial();
  InventDto invent = const InventDto.initial();
  GameStatus gameStatus = GameStatus.initial;

  SpaceGameBloc()
      : super(const SpaceGameStatusChanged(status: GameStatus.initial)) {
    on<ScoreAddEvent>(_gameLoopAddScore);
    on<PlayerDiedEvent>(_gameLoopPlayerDied);
    on<PlayerFireEvent>(_gameLoopPlayerFire);
    on<GameLoadedEvent>(_gameLoopGameLoaded);
    on<OpenInitialScreenEvent>(_gameLoopOpenInitialScreen);
    on<OpenStatisticScreenEvent>(_gameLoopOpenStatisticsScreen);
    on<BonusArmorEvent>(_bonusArmor);
    on<PlayerArmorEvent>(_gameLoopPlayerArmor);
    on<BonusBombEvent>(_bonusBomb);
    on<BonusHpEvent>(_bonusHp);
    on<BonusMultiRocketEvent>(_bonusMultiRocket);
    on<BonusRocketEvent>(_bonusRocket);
    on<BonusSpeedEvent>(_bonusSpeed);
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
    print(
        '\nBLoC: gameLoopPlayerDied statistic: $statistic gs: $gameStatus START');
    statistic = statistic.copyWith(brokenLives: statistic.brokenLives + 1);

    print('BLoC: gameLoopPlayerDied statistic: $statistic gs: $gameStatus');
    if (statistic.brokenLives >= statistic.maxLivesCount) {
      emit(SpaceGameStatusChanged(
          status: GameStatus.gameOver, data: statistic.score));
      await ResultsRepository.getInstance()
          .addItem(Result(score: statistic.score, dt: DateTime.now()));
      emit(StatisticChangedState(statistic: statistic));
    } else {
      await Future.delayed(
          const Duration(seconds: 1), () => respawnPlayer(emit));
    }
  }

  FutureOr<void> respawnPlayer(Emitter emit) async {
    gameStatus = GameStatus.respawn;
    emit(const SpaceGameStatusChanged(status: GameStatus.respawn));
    emit(StatisticChangedState(statistic: statistic));
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
    if (gameStatus == GameStatus.respawned ||
        gameStatus == GameStatus.respawn) {
      int rocketCount = invent.rocket - 1;
      if (rocketCount >= 0) {
        invent = invent.copyWith(rocket: rocketCount);
        emit(PlayerFireState(rocketCount));
        emit(InventChangedState(invent: invent));
      } else {
        rocketCount = 0;
      }
    }
  }

  FutureOr<void> _gameLoopAddScore(
    final ScoreAddEvent event,
    final Emitter<SpaceGameState> emit,
  ) {
    statistic = statistic.copyWith(score: statistic.score + event.scoreDelta);
    emit(StatisticChangedState(statistic: statistic));
  }

  FutureOr<void> _gameLoopOpenInitialScreen(
      final OpenInitialScreenEvent event, final Emitter<SpaceGameState> emit) {
    statistic = const StatisticDto.initial();
    invent = const InventDto.initial();
    gameStatus = GameStatus.initial;
    emit(const SpaceGameStatusChanged(status: GameStatus.initial));
  }

  FutureOr<void> _gameLoopOpenStatisticsScreen(
      final OpenStatisticScreenEvent event,
      final Emitter<SpaceGameState> emit) async {
    var results = await ResultsRepository.getInstance().getItems();
    emit(SpaceGameStatusChanged(status: GameStatus.statistics, data: results));
  }

  FutureOr<void> _bonusArmor(
      final BonusArmorEvent event, final Emitter<SpaceGameState> emit) {
    invent = invent.copyWith(armor: invent.armor + 5);
    print('_bonusArmor $invent');
    emit(InventChangedState(invent: invent));
  }

  FutureOr<void> _gameLoopPlayerArmor(
      final PlayerArmorEvent event, final Emitter<SpaceGameState> emit) async {
    print('START: _gameLoopPlayerArmor');
    emit(const PlayerArmorState(armorIsActive: true));
    final tickCount = invent.armor;
    final timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int armorCount = invent.armor - 1;
      if (armorCount < 0) {
        armorCount = 0;
      }
      invent = invent.copyWith(armor: armorCount);
      print('MIDDLE: _gameLoopPlayerArmor $armorCount');
      emit(InventChangedState(invent: invent));
    });

    await Future.delayed(
      Duration(seconds: tickCount + 1),
      () {
        timer.cancel();
        emit(const PlayerArmorState(armorIsActive: false));
        print('END: _gameLoopPlayerArmor');
      },
    );
  }

  Future<void> armorTimer() async {}

  FutureOr<void> _bonusBomb(
      final BonusBombEvent event, final Emitter<SpaceGameState> emit) {}

  FutureOr<void> _bonusHp(
      final BonusHpEvent event, final Emitter<SpaceGameState> emit) {
    print ('BonusHp STAEFT $statistic');
    final sts = statistic;
    statistic = statistic.copyWith(maxLivesCount: statistic.maxLivesCount + 1);
    print ('END BonusHp $statistic ${sts == statistic}');
    emit(StatisticChangedState(statistic: statistic));
  }

  FutureOr<void> _bonusMultiRocket(
      final BonusMultiRocketEvent event, final Emitter<SpaceGameState> emit) {}

  FutureOr<void> _bonusRocket(
      final BonusRocketEvent event, final Emitter<SpaceGameState> emit) {}

  FutureOr<void> _bonusSpeed(
      final BonusSpeedEvent event, final Emitter<SpaceGameState> emit) {}
}
