import 'dart:async';

import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:spacehero/entities/abs_entity.dart';
import 'package:spacehero/entities/asteroid.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/entities/bullet.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class Bomb extends Entity with HasGameRef<SpaceGame> {
  bool _isDestroyingFlag = false;

  Bomb(
      {required double startPositionX,
      required double startPositionY,
      super.placePriority = 4}) {
    initializeCoreVariables(speed: 0, side: AppConstants.bombSideSize);
    x = startPositionX;
    y = startPositionY;
  }

  @override
  Future<void> onLoad() async {
    final sResult = await super.onLoad();
    final sprites = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
        .map((i) => Sprite.load('bomb_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.2,
    );
    return sResult;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (_isDestroyingFlag) {
      return;
    }
    if (other is Asteroid) {
      _isDestroyingFlag = true;
      if (!other.isDestroying) {
        gameRef.bloc.add(const ScoreAddEvent(scoreDelta: 1));
      }
      other.setDestroying = true;
      changeAnimation(
        onStart: () {},
        onFrame: (currentSpriteIndex) {
          if (currentSpriteIndex == 2) {
            other.add(OpacityEffect.to(
              0,
              onComplete: () => other.removeFromParent(),
              EffectController(
                curve: Curves.ease,
                duration: 0.5,
              ),
            ));
          } else if (currentSpriteIndex == 3) {
            size = size * 8;
            add(CircleHitbox(
                anchor: Anchor.center,
                radius: size.x * 0.8 / 2,
                position: size / 2));
          }
        },
      );
    } else if (other is Bomb) {
      _isDestroyingFlag = true;
      changeAnimation(
        onStart: () {},
        onFrame: (currentSpriteIndex) {
          if (currentSpriteIndex <= 5) {
            size = size +
                Vector2(AppConstants.bombSideSize, AppConstants.bombSideSize);
            add(CircleHitbox(
                anchor: Anchor.center,
                radius: size.x * 0.8 / 2,
                position: size / 2));
          }
        },
      );
    } else if (other is Bullet) {
      _isDestroyingFlag = true;
      changeAnimation(
        onStart: () => other.removeFromParent(),
        onFrame: (currentSpriteIndex) {
          if (currentSpriteIndex == 2) {
            size = size * 8;
            add(CircleHitbox(
                anchor: Anchor.center,
                radius: size.x * 0.8 / 2,
                position: size / 2));
          }
        },
      );
    } else if (other is BlackHole) {
      _isDestroyingFlag = true;
      add(MoveToEffect(
        other.position,
        EffectController(
          duration: 2,
          curve: Curves.easeInOutCirc,
        ),
      ));
      add(ScaleEffect.by(
        Vector2.all(0.1),
        onComplete: () {
          removeFromParent();
        },
        EffectController(
          curve: Curves.easeInOutCirc,
          duration: 2,
        ),
      ));
    }
  }

  FutureOr<void> changeAnimation(
      {required void Function() onStart,
      required void Function(int) onFrame}) async {
    final sprites = [0, 1, 2, 3, 4, 5, 6, 7, 8]
        .map((i) => Sprite.load('bomb_explosion_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(await Future.wait(sprites),
        stepTime: 0.05, loop: false)
      ..onComplete = () {
        removeFromParent();
      }
      ..onStart = onStart
      ..onFrame = onFrame;
  }

  @override
  void animateEntity(double dt) {}
}
