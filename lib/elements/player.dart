import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/elements/asteroid.dart';
import 'package:spacehero/elements/black_hole.dart';
import 'package:spacehero/flame/space_game.dart';

class Player extends Entity with HasGameRef<SpaceGame> {
  static const _shipSideSize = 80.0;
  static const double _speed = 1;
  static const int _angleCoefficient = 80;

  bool gameOver = false;

  Player(
      {required super.screenWidth,
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
    if (gameOver) {
      return;
    }
    if (other is Asteroid) {
      other.setSpeed = 0;
      changeAnimation();
    } else if (other is BlackHole) {
      changeAnimation();
    }
  }

  FutureOr<void> changeAnimation() async {
    //TODO GAME OVER убрать
//    gameOver = true;
    final sprites = [0, 1, 2, 3, 4, 5, 6]
        .map((i) => Sprite.load('plane_explosion_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(await Future.wait(sprites),
        stepTime: 0.3, loop: false)
      ..onComplete = () {
        print('Game Over');
        removeEntity();
      };
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
    if (!gameOver) {
      animateEntity(dt);
    }
  }

  @override
  void animateEntity(double dt) {
    move();
  }
}
