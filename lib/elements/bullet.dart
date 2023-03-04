import 'dart:async';
import 'dart:math';
import 'package:flame/components.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/elements/asteroid.dart';
import 'package:spacehero/elements/black_hole.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';

class Bullet extends Entity with HasGameRef<SpaceGame> {
  static const _bulletSideSize = 20.0;
  static const _bulletSpeed = 9.0;

  final double shootAngle;

  Bullet(
      {required super.screenWidth,
      required super.screenHeight,
      required double startPositionX,
      required double startPositionY,
      required this.shootAngle,
      super.placePriority = 3}) {
    initializeCoreVariables(speed: _bulletSpeed, side: _bulletSideSize);
    x = startPositionX;
    y = startPositionY;
    angle = shootAngle;
  }

  @override
  FutureOr<void> onLoad() async {
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
      size = other.size * 3; // TODO анимировать увеличение размера
      other.setSpeed = 0;
      other.setDestroyed = true;
      gameRef.score++;
      changeAnimation(other);
    } else if (other is BlackHole) {
      removeEntity();
    }
  }

  FutureOr<void> changeAnimation(Entity other) async {
    final sprites = [1, 2, 3, 4, 5, 6, 7, 8]
        .map((i) => Sprite.load('bullet_explosion_$i.png'))
        .toList();
    animation = SpriteAnimation.spriteList(await Future.wait(sprites),
        stepTime: 0.2, loop: false)
      ..onComplete = () {
        removeEntity();
      }
      ..onFrame = (value) {
        if (value == 5) other.removeEntity(); // TODO возможно анимировать opacity
      };
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
