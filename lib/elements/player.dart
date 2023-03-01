import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/flame/space_game.dart';

class Player extends Entity with HasGameRef<SpaceGame> {
  static const _shipSideSize = 50.0;
  static const double _speed = 3;
  static const int _angleCoefficient = 80;

  Player({
    required super.spriteName,
    required super.screenWidth,
    required super.screenHeight,
  }) {
    size = Vector2(_shipSideSize, _shipSideSize);
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
    x += sin(angle) * _speed;
    y -= cos(angle) * _speed;

    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > screenWidth) x = screenWidth;
    if (y > screenHeight) y = screenHeight;
  }

  @override
  void animate(double dt) {
    move();
  }
}
