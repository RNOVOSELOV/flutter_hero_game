import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/flame/space_game.dart';

class Player extends SpriteComponent with HasGameRef<SpaceGame> {
  static const _shipSideSize = 50.0;
  static const int _angleCoefficient = 80;
  static const double _speed = 3;

  @override
  FutureOr<void> onLoad() async {
    await super.onLoad();
    sprite = await gameRef.loadSprite('player0.png');
    size = Vector2(_shipSideSize, _shipSideSize);
    anchor = Anchor.center;

    final screenSize = gameRef.size;
    x = screenSize[0] / 2;
    y = screenSize[1] / 4 * 3;
  }

  void rotate(double dx) {
    if (dx != 0) {
      angle += dx / _angleCoefficient;
    }
  }

  void move() {
    x += sin(angle) * _speed;
    y -= cos(angle) * _speed;

    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > gameRef.size[0]) x = gameRef.size[0];
    if (y > gameRef.size[1]) y = gameRef.size[1];
  }
}
