import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:spacehero/entities/abs_entity.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class BlackHole extends Entity with HasGameRef<SpaceGame> {
  // Угол вращения вокруг собственной оси
  late final double _angleRotationSpeed;
  bool removeFlag = false;

  BlackHole({
    required Vector2 gameplayArea,
    super.placePriority = 1,
  }) {
    final random = Random(DateTime
        .now()
        .microsecond);
    final double generatedSpeed = AppConstants.blackHoleMinimumRotationSpeed +
        random.nextDouble() *
            AppConstants.blackHolAdditionalRandomRotationSpeed;
    final double generatedSideSize = AppConstants.blackHolMinimumSideSize +
        random.nextDouble() * AppConstants.blackHolAdditionalRandomSideSize;
    initializeCoreVariables(speed: generatedSpeed, side: generatedSideSize);

    x = random.nextDouble() * (gameplayArea[0] - sideSize) + sideSize / 2;
    y = random.nextDouble() * (gameplayArea[1] - sideSize) + sideSize / 2;
    _angleRotationSpeed = random.nextDouble() + speed / 4;
    scale = Vector2(0.3, 0.3);
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    final sprites = [0].map((i) => Sprite.load('black_hole.png')).toList();
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 5,
      loop: false,
    );
    return sResult;
  }

  void rotate(double dx) {
    angle += _angleRotationSpeed * dx;
    angle %= 2 * pi;
  }

  @override
  void animateEntity(double dt) {
    rotate(dt);
    if (removeFlag) {
      return;
    }
    if (scale.x <= 1) {
      scale = Vector2(scale.x + dt / 2, scale.x + dt / 2);
    }
  }

  void removeEntity() {
    removeFlag = true;
    final Effect effect = ScaleEffect.by(
      Vector2.all(0.1),
      onComplete: () => removeFromParent(),
      EffectController(
        curve: Curves.bounceIn,
        duration: 2,
      ),
    );
    add(effect);
  }
}
