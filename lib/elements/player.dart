import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/elements/asteroid.dart';
import 'package:spacehero/elements/black_hole.dart';
import 'package:spacehero/flame/space_game.dart';

class Player extends Entity with HasGameRef<SpaceGame> {
  static const _shipSideSize = 80.0;
  static const double _speed = 1;
  static const int _angleCoefficient = 80;

  Player(
      {
      required super.screenWidth,
      required super.screenHeight,
      super.placePriority = 4}) {
    initializeCoreVariables(speed: _speed, side: _shipSideSize);
    x = screenWidth / 2;
    y = screenHeight / 4 * 3;
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    final sprites =
        [0, 1, 2, 3, 4, 5].map((i) => Sprite.load('plane_$i.png')).toList();
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
    );
    return sResult;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    // TODO GAME OVER
    if (other is Asteroid) {
      setVisible = false;
    } else if (other is BlackHole) {
      setVisible = false;
    }
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
