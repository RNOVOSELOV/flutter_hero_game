import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/elements/asteroid.dart';
import 'package:spacehero/elements/bullet.dart';
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
    required super.spriteName,
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
    scale = Vector2(0, 0);
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    sprite = await gameRef.loadSprite(spriteName);
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
      final currScale = scale.x - dt;
      if (currScale <= 0) {
        removeEntity();
      }
      scale = Vector2(currScale, currScale);
    } else if (scale.x <= 1) {
      scale = Vector2(scale.x + dt, scale.x + dt);
    }
  }

  @override
  void removeEntity() {
    if (removeFlag) {
      super.removeEntity();
    } else {
      removeFlag = true;
    }
  }
}
