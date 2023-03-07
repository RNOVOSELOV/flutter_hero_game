import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/animation.dart';
import 'package:spacehero/entities/abs_entity.dart';
import 'package:spacehero/entities/asteroid.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/entities/bullet.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class Player extends Entity
    with
        HasGameRef<SpaceGame>,
        FlameBlocListenable<SpaceGameBloc, SpaceGameState> {
  bool respawnModeIsActive = true;

  Player({
    required Vector2 gameplayArea,
    super.placePriority = 4,
  }) {
    setPlayerParameters(gameplayArea: gameplayArea);
  }

  void setPlayerParameters({required Vector2 gameplayArea}) {
    initializeCoreVariables(
        speed: AppConstants.playerSpeed, side: AppConstants.playerShipSideSize);
    x = gameplayArea[0] / 2;
    y = gameplayArea[1] / 4 * 3;
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    await loadRespawnSprites();
    return sResult;
  }

  FutureOr<void> loadRespawnSprites() async {
    final sprites = [0, 1, 2, 3, 4, 5, 10, 10, 10]
        .map((i) => Sprite.load('plane_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
    );
  }

  FutureOr<void> respawnModeEnd() async {
    respawnModeIsActive = false;
    final sprites =
        [0, 1, 2, 3, 4, 5].map((i) => Sprite.load('plane_$i.png')).toList();
    animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: 0.1,
    );
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
    if (respawnModeIsActive) {
      return;
    }
    if (other is Asteroid) {
      if (other.isDestroying) {
        return;
      }
      other.setDestroying = true;
      setSpeed = 0;
      other.setSpeed = 0;
      liveBrokenByAsteroid(other);
    } else if (other is BlackHole) {
      liveBrokenByBlackHole(other.position);
    }
  }

  FutureOr<void> liveBrokenByAsteroid(Asteroid other) async {
    final sprites = [0, 1, 2, 3, 4, 5, 6]
        .map((i) => Sprite.load('plane_explosion_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(await Future.wait(sprites),
        stepTime: 0.2, loop: false)
      ..onComplete = () {
        bloc.add(const PlayerDiedEvent());
        removeFromParent();
      }
      ..onFrame = (value) {
        if (value == 3) {
          size = other.size * 4;
          other.add(OpacityEffect.to(
            0,
            onComplete: () => other.removeFromParent(),
            EffectController(
              curve: Curves.ease,
              duration: 0.01,
            ),
          ));
        }
      };
  }

  FutureOr<void> liveBrokenByBlackHole(Vector2 position) async {
    setSpeed = 0;
    add(MoveToEffect(
      position,
      EffectController(
        duration: 2,
        curve: Curves.easeInOutCirc,
      ),
    ));
    add(ScaleEffect.by(
      Vector2.all(0.1),
      onComplete: () {
        bloc.add(const PlayerDiedEvent());
        removeFromParent();
      },
      EffectController(
        curve: Curves.easeInOutCirc,
        duration: 2,
      ),
    ));
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
  void animateEntity(double dt) {
    move();
  }
}
