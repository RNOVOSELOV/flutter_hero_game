import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/flame/space_game.dart';

class Player extends Entity with HasGameRef<SpaceGame> {
  static const _shipSideSize = 50.0;
  static const double _speed = 3;
  static const int _angleCoefficient = 80;

  @override
  double get angleDirection => angle;

  Player({
    required super.spriteName,
    required super.screenWidth,
    required super.screenHeight,
  }) {
    initializeCoreVariables(speed: _speed, side: _shipSideSize);
    x = screenWidth / 2;
    y = screenHeight / 4 * 3;
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    sprite = await gameRef.loadSprite(spriteName);
    return sResult;
  }

  void rotate({double? dx}) {
    if (dx != null) {
      angle += dx / _angleCoefficient;
    }
  }

  void move() {
    x += sin(angle) * speed;
    y -= cos(angle) * speed;

    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > screenWidth) x = screenWidth;
    if (y > screenHeight) y = screenHeight;
  }

  @override
  void update(double dt) {
    super.update(dt);
    animateEntity(dt);
  }

  @override
  void animateEntity(double dt) {
    move();
  }
}
