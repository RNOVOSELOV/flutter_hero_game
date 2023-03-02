import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/elements/asteroid.dart';
import 'package:spacehero/elements/black_hole.dart';
import 'package:spacehero/flame/space_game.dart';

class Bullet extends Entity with HasGameRef<SpaceGame> {
  static const _bulletSideSize = 10.0;
  static const _bulletSpeed = 12.0;

  final double shootAngle;

  Bullet(
      {required super.spriteName,
      required super.screenWidth,
      required super.screenHeight,
      required double startPositionX,
      required double startPositionY,
      required this.shootAngle,
      super.placePriority = 3}) {
    initializeCoreVariables(speed: _bulletSpeed, side: _bulletSideSize);
    x = startPositionX;
    y = startPositionY;
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    sprite = await gameRef.loadSprite(spriteName);
    return sResult;
  }

  @override
  void onCollisionStart(
      Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);
    if (other is Asteroid || other is BlackHole) {
      removeEntity();
    }
  }

  void move() {
    position.x += sin(shootAngle) * speed;
    position.y -= cos(shootAngle) * speed;
  }

  @override
  void animateEntity(double dt) {
    move();
  }
}
