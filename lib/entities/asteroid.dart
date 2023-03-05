import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/animation.dart';
import 'package:spacehero/entities/abs_entity.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/entities/models/entity_move_parameters.dart';
import 'package:spacehero/entities_controllers/asteroid_controller.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';
import 'package:spacehero/utils/math_helper.dart';

class Asteroid extends Entity with HasGameRef<SpaceGame> {
  bool asteroidCollisionFlag = false;
  bool destroyedFlag = false;

  // Угол направления движения астороида
  late double _angleDirection;

  // Угол вращения астероида вокруг собственной оси
  late double _angleRotationSpeed;

  double get angleDirection => _angleDirection;

  set setAngleDirection(double value) => _angleDirection = value;

  bool get isDestroyed => destroyedFlag;

  set setDestroyed(bool flag) => destroyedFlag = flag;

  Asteroid({
    required Vector2 gameplayArea,
    super.placePriority = 2,
  }) {
    setAsteroidParameters(gameplayArea: gameplayArea);
  }

  void setAsteroidParameters({required Vector2 gameplayArea}) {
    final random = Random(DateTime.now().microsecond);
    final double generatedSpeed = AppConstants.asteroidMinimumSpeed +
        random.nextDouble() * AppConstants.asteroidAdditionalRandomSpeed;
    final double generatedSideSize = AppConstants.asteroidMinimumSideSize +
        random.nextDouble() * AppConstants.asteroidAdditionalRandomSideSize;
    initializeCoreVariables(speed: generatedSpeed, side: generatedSideSize);

    final asteroidInfo = AsteroidHelper.getAsteroidStartPositionValue(
        maxWidth: gameplayArea[0],
        maxHeight: gameplayArea[1],
        asteroidSide: sideSize);

    position = asteroidInfo.position;
    _angleDirection = asteroidInfo.angle == null ? 0 : asteroidInfo.angle!;
    _angleRotationSpeed =
        random.nextDouble() * (random.nextBool() ? (-1) : 1) + speed / 4;
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    await loadSprites();
    return sResult;
  }

  FutureOr<void> loadSprites() async {
    final sprites = [0]
        .map((i) => Sprite.load(AsteroidHelper.getAsteroidSpriteName()))
        .toList();
    animation =
        SpriteAnimation.spriteList(await Future.wait(sprites), stepTime: 5);
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (destroyedFlag) {
      return;
    }
    if (other is Asteroid) {
      if (other.isDestroyed) {
        return;
      }
      final Asteroid asteroid = other;
      if (asteroidCollisionFlag) {
        asteroidCollisionFlag = false;
        asteroid.asteroidCollisionFlag = false;
        return;
      }
      asteroidCollisionFlag = true;
      asteroid.asteroidCollisionFlag = true;
      changeAsteroidParameters(other);
    } else if (other is BlackHole) {
      final holePosition = other.position;
      final newAngle = getAngle(position, holePosition);
      _angleDirection = getShortAngle(_angleDirection, newAngle);
      setAsteroidMovingParameters(
          EntityMoveParameters(angle: angleDirection, speed: 2));

      add(ScaleEffect.by(
        Vector2.all(0.1),
        onComplete: () => removeFromParent(),
        EffectController(
          curve: Curves.easeOutQuad,
          duration: 2,
        ),
      ));
    }
  }

  void changeAsteroidParameters(Asteroid other) {
    final otherParams = EntityMoveParameters.fromAsteroid(asteroid: other);
    other.setAsteroidMovingParameters(
        EntityMoveParameters.fromAsteroid(asteroid: this));
    setAsteroidMovingParameters(otherParams);
  }

  void setAsteroidMovingParameters(EntityMoveParameters parameters) {
    setAngleDirection = parameters.angle;
    setSpeed = parameters.speed;
  }

  @override
  void animateEntity(double dt) {
    if (!asteroidIsAvailable()) {
      loadSprites();
      setAsteroidParameters(gameplayArea: gameRef.size);
      return;
    }
    move();
    rotate(dt);
    // if (removeScaleFlag) {
    //   final currScale = scale.x - dt * 1.5;
    //   if (currScale <= 0) {
    //     removeEntity();
    //   }
    //   scale = Vector2(currScale, currScale);
    // }
  }

  void move() {
    position.x = position.x + sin(_angleDirection) * speed;
    position.y = position.y - cos(_angleDirection) * speed;
  }

  void rotate(double dx) {
    angle += _angleRotationSpeed * dx;
    angle %= 2 * pi;
  }

  bool asteroidIsAvailable() {
    if (position.x > gameRef.getScreenWidth || //+ sideSize ||
        position.y > gameRef.getScreenHeight || //+ sideSize ||
        position.x < 0 || // - sideSize ||
        position.y < 0 ){//- sideSize) {
      return false;
    }
    return true;
  }
}
