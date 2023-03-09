import 'dart:math';
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/entities/bonus.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class BonusController extends TimerComponent
    with
        HasGameRef<SpaceGame>,
        FlameBlocListenable<SpaceGameBloc, SpaceGameState> {
  Bonus? bonus;
  bool isGameMode = false;

  BonusController()
      : super(period: AppConstants.bonusGenerationTimeInSeconds, repeat: true);

  @override
  bool listenWhen(SpaceGameState previousState, SpaceGameState newState) {
    return newState is SpaceGameStatusChanged;
  }

  @override
  void onNewState(SpaceGameState state) {
    if (state is SpaceGameStatusChanged) {
      if (state.status == GameStatus.respawn || state.status == GameStatus.respawned) {
        isGameMode = true;
      } else {
        isGameMode = false;
      }
    }
  }

  @override
  void onTick() {
    if (!isGameMode) {
      return;
    }
    if (bonus != null) {
      bonus!.removeEntity();
      bonus = null;
    } else {
      final bonusParameter = BonusParametersKeeper
          .bonus4; //BonusParametersKeeper.getRandomBonusParameter();

      bonus = Bonus(
          gameplayArea: gameRef.size,
          spriteName: bonusParameter.getImageName,
          onBonusCollisionCallback: bonusParameter.getCallback);
      parent?.add(bonus!);
      print('Bonus created! ${bonus!.getStringInfo()}');
    }
  }
}

class BonusParametersKeeper extends Equatable {
  final String _spriteName;

  final void Function(SpaceGameBloc bloc) _onBonusCollisionCallback;

  String get getImageName => _spriteName;

  void Function(SpaceGameBloc bloc) get getCallback =>
      _onBonusCollisionCallback;

  const BonusParametersKeeper._(
      {required String spriteName,
      required void Function(SpaceGameBloc) onBonusCollisionCallback})
      : _onBonusCollisionCallback = onBonusCollisionCallback,
        _spriteName = spriteName;

  static final bonus1 = BonusParametersKeeper._(
      spriteName: "_armor.png",
      onBonusCollisionCallback: (bloc) => bloc.add(const BonusArmorEvent()));
  static final bonus2 = BonusParametersKeeper._(
      spriteName: "_bomb.png",
      onBonusCollisionCallback: (bloc) => bloc.add(const BonusBombEvent()));
  static final bonus3 = BonusParametersKeeper._(
      spriteName: "_hp.png",
      onBonusCollisionCallback: (bloc) => bloc.add(const BonusHpEvent()));
  static final bonus4 = BonusParametersKeeper._(
      spriteName: "_rocket.png",
      onBonusCollisionCallback: (bloc) => bloc.add(const BonusRocketEvent()));
  static final bonus5 = BonusParametersKeeper._(
      spriteName: "_speed.png",
      onBonusCollisionCallback: (bloc) => bloc.add(const BonusSpeedEvent()));
//  static final bonus6 = BonusParametersKeeper._(
//      spriteName: "_rockets.png",
//      onBonusCollisionCallback: (bloc) =>
//          bloc.add(const BonusMultiRocketEvent()));

  static final values = [
    bonus1,
    bonus2,
    bonus3,
    bonus4,
    bonus5,
//    bonus6,
  ];

  static BonusParametersKeeper getRandomBonusParameter() {
    final randomIndex =
        Random(DateTime.now().microsecond).nextInt(values.length);
    return values.elementAt(randomIndex);
  }

  @override
  List<Object?> get props => [_spriteName];
}
