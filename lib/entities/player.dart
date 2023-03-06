import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:spacehero/entities/abs_entity.dart';
import 'package:spacehero/entities/asteroid.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/entities/bullet.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class Player extends Entity
    with
        HasGameRef<SpaceGame>,
        FlameBlocListenable<SpaceGameBloc, SpaceGameState> {
  bool gameOver = false;

  Player({
    required Vector2 gameplayArea,
    super.placePriority = 4,
  }) {
    initializeCoreVariables(
        speed: AppConstants.playerSpeed, side: AppConstants.playerShipSideSize);
    x = gameplayArea[0] / 2;
    y = gameplayArea[1] / 4 * 3;
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
  bool listenWhen(SpaceGameState previousState, SpaceGameState newState) {
    return newState is PlayerFireState;
  }

  @override
  void onNewState(SpaceGameState state) {
    super.onNewState(state);
    Entity bullet = Bullet(
        shootAngle: angle,
        startPositionX: position.x,
        startPositionY: position.y);
    gameRef.add(bullet);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (gameOver) {
      return;
    }
    if (other is Asteroid) {
      if (other.isDestroyed) {
        return;
      }
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
//        removeEntity();
      };
  }

  void rotate({double? dx}) {
    if (dx != null) {
      angle += dx / AppConstants.playerAngleRotationCoefficient;
    }
  }

  void move() {
    x += sin(angle) * speed;
    y -= cos(angle) * speed;

    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > gameRef.getScreenWidth) x = gameRef.getScreenWidth;
    if (y > gameRef.getScreenHeight) y = gameRef.getScreenHeight;
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
