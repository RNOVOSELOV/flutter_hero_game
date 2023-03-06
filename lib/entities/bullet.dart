import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:spacehero/entities/abs_entity.dart';
import 'package:spacehero/entities/asteroid.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class Bullet extends Entity with HasGameRef<SpaceGame> {
  final double shootAngle;

  Bullet(
      {required double startPositionX,
      required double startPositionY,
      required this.shootAngle,
      super.placePriority = 3}) {
    initializeCoreVariables(
        speed: AppConstants.bulletSpeed, side: AppConstants.bulletSideSize);
    x = startPositionX;
    y = startPositionY;
    angle = shootAngle;
  }

  @override
  Future<void> onLoad() async {
    final sResult = await super.onLoad();
    final sprites = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        .map((i) => Sprite.load('bullet_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.5,
    );
    return sResult;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Asteroid) {
      setSpeed = 0;
      other.setSpeed = 0;
      other.setDestroying = true;
      gameRef.bloc.add(const ScoreAddEvent(scoreDelta: 1));
      changeAnimation(other);
    } else if (other is BlackHole) {
      removeFromParent();
    }
  }

  FutureOr<void> changeAnimation(Entity other) async {
    final sprites = [1, 2, 3, 4, 5, 6, 7, 8]
        .map((i) => Sprite.load('bullet_explosion_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(await Future.wait(sprites),
        stepTime: 0.2, loop: false)
      ..onComplete = () {
        removeFromParent();
      }
      ..onFrame = (value) {
        if (value == 1) {
          size = other.size * 3;
        } else if (value == 3) {
          other.add(OpacityEffect.to(
            0,
            onComplete: () => other.removeFromParent(),
            EffectController(
              curve: Curves.ease,
              duration: 0.5,
            ),
          )); // TODO возможно анимировать opacity
        }
      };
  }

  void move() {
    position.x += sin(shootAngle) * speed;
    position.y -= cos(shootAngle) * speed;
  }

  @override
  void animateEntity(double dt) {
    move();
    if (!bulletIsAvailable()) {
      removeFromParent();
    }
  }

  bool bulletIsAvailable() {
    if (position.x > gameRef.getScreenWidth + sideSize ||
        position.y > gameRef.getScreenHeight + sideSize ||
        position.x < 0 - sideSize ||
        position.y < 0 - sideSize) {
      return false;
    }
    return true;
  }
}
