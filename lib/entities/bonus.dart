import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:spacehero/entities/abs_entity.dart';
import 'package:spacehero/entities/bullet.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class Bonus extends Entity with HasGameRef<SpaceGame> {
  bool removeFlag = false;
  final String spriteName;
  final void Function(SpaceGameBloc bloc) onBonusCollisionCallback;

  Bonus({
    required this.spriteName,
    required this.onBonusCollisionCallback,
    required Vector2 gameplayArea,
    super.placePriority = 3,
  }) {
    final random = Random(DateTime.now().second);
    initializeCoreVariables(speed: 0, side: AppConstants.bonusSideSide);
    x = random.nextDouble() * (gameplayArea[0] - sideSize) + sideSize / 2;
    y = random.nextDouble() * (gameplayArea[1] - sideSize) + sideSize / 2;
    scale = Vector2(0.3, 0.3);
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    final sprites = [0].map((i) => Sprite.load(spriteName)).toList();
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 5,
      loop: true,
    );
    return sResult;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (removeFlag) {
      return;
    }
    if (other is Player || other is Bullet) {
      onBonusCollisionCallback(gameRef.bloc);
      removeEntity();
    } else {
      removeEntity();
    }
  }

  @override
  void animateEntity(double dt) {
    if (removeFlag) {
      return;
    }
    if (scale.x <= 1) {
      scale = Vector2(scale.x + dt / 2, scale.x + dt / 2);
    }
  }

  void removeEntity() {
    removeFlag = true;
    final Effect effect = SequenceEffect([
      ScaleEffect.by(
        Vector2.all(1.5),
        EffectController(
          curve: Curves.ease,
          duration: 0.5,
        ),
      ),
      ScaleEffect.by(
        Vector2.all(0.2),
        onComplete: () {
          removeFromParent();
        },
        EffectController(
          curve: Curves.ease,
          duration: 1.5,
        ),
      ),
    ]);
    add(effect);
  }
}
