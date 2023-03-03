import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/flame/space_game.dart';

class BlackHole extends Entity with HasGameRef<SpaceGame> {
  static const _minimumHoleRotationSpeed = 2;
  static const _additionalRandomHoleRotationSpeed = 2;
  static const _minimumHoleSideSize = 100;
  static const _additionalRandomHoleSideSize = 40;

  // Угол вращения вокруг собственной оси
  late final double _angleRotationSpeed;
  bool removeFlag = false;

  BlackHole({
    required super.screenWidth,
    required super.screenHeight,
  }) {
    final random = Random(DateTime.now().microsecond);
    final double generatedSpeed = _minimumHoleRotationSpeed +
        random.nextDouble() * _additionalRandomHoleRotationSpeed;
    final double generatedSideSize = _minimumHoleSideSize +
        random.nextDouble() * _additionalRandomHoleSideSize;
    initializeCoreVariables(speed: generatedSpeed, side: generatedSideSize);

    x = random.nextDouble() * (screenWidth - sideSize) + sideSize / 2;
    y = random.nextDouble() * (screenHeight - sideSize) + sideSize / 2;
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

  @override
  void removeEntity() {
    removeFlag = true;
    add(ScaleEffect.by(
      Vector2.all(0.1),
      onComplete: () => super.removeEntity(),
      EffectController(
        curve: Curves.bounceIn,
        duration: 2,
      ),
    ));
  }
}
