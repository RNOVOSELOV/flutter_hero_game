import 'dart:async';
import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/elements/entity_initial_info.dart';
import 'package:spacehero/flame/space_game.dart';

class Asteroid extends Entity with HasGameRef<SpaceGame> {
  static const _minimumAsteroidSpeed = 2;
  static const _additionalRandomAsteroidSpeed = 3;
  static const _minimumAsteroidSideSize = 30;
  static const _additionalRandomAsteroidSideSize = 50;

  // Угол направления движения астороида
  late final double _angleDirection;

  // Угол вращения астероида вокруг собственной оси
  late final double _angleRotationSpeed;

  @override
  double get angleDirection => _angleDirection;

  Asteroid({
    required super.spriteName,
    required super.screenWidth,
    required super.screenHeight,
  }) {
    final random = Random(DateTime.now().microsecond);
    final double generatedSpeed = _minimumAsteroidSpeed +
        random.nextDouble() * _additionalRandomAsteroidSpeed;
    final double generatedSideSize = _minimumAsteroidSideSize +
        random.nextDouble() * _additionalRandomAsteroidSideSize;
    initializeCoreVariables(speed: generatedSpeed, side: generatedSideSize);

    final asteroidInfo = AsteroidHelper.getAsteroidStartValue(
        maxWidth: screenWidth,
        maxHeight: screenHeight,
        randomAngle: random.nextDouble() * pi,
        asteroidSide: sideSize);
    x = asteroidInfo.x;
    y = asteroidInfo.y;
    _angleDirection = asteroidInfo.angle == null ? 0 : asteroidInfo.angle!;
    _angleRotationSpeed =
        random.nextDouble() * (random.nextBool() ? (-1) : 1) + speed / 4;
  }

  @override
  FutureOr<void> onLoad() async {
    final sResult = await super.onLoad();
    sprite = await gameRef.loadSprite(spriteName);
    return sResult;
  }

  void move() {
    position.x = position.x + sin(_angleDirection) * speed;
    position.y = position.y - cos(_angleDirection) * speed;
  }

  void rotate(double dx) {
    angle += _angleRotationSpeed * dx;
    angle %= 2 * pi;
  }

  @override
  void animateEntity(double dt) {
    move();
    rotate(dt);
  }
}

class AsteroidHelper {
  final String typeName;

  const AsteroidHelper._(this.typeName);

  static const asteroid1 = AsteroidHelper._("asteroid1.png");
  static const asteroid2 = AsteroidHelper._("asteroid2.png");
  static const asteroid3 = AsteroidHelper._("asteroid3.png");
  static const asteroid4 = AsteroidHelper._("asteroid4.png");
  static const asteroid5 = AsteroidHelper._("asteroid5.png");
  static const asteroid6 = AsteroidHelper._("asteroid6.png");
  static const asteroid7 = AsteroidHelper._("asteroid7.png");
  static const asteroid8 = AsteroidHelper._("asteroid8.png");
  static const asteroid9 = AsteroidHelper._("asteroid9.png");

  static const values = [
    asteroid1,
    asteroid2,
    asteroid3,
    asteroid4,
    asteroid5,
    asteroid6,
    asteroid7,
    asteroid8,
    asteroid9,
  ];

  static String getAsteroidSpriteName() {
    final randomIndex =
        Random(DateTime.now().microsecond).nextInt(values.length);
    return values.elementAt(randomIndex).typeName;
  }

  @override
  String toString() {
    return typeName;
  }

  static EntityInitialInfo<double> getAsteroidStartValue({
    required double maxWidth,
    required double maxHeight,
    required double randomAngle,
    required double asteroidSide,
  }) {
    double width = 0;
    double height = 0;
    double angle;
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final isFixWidth = random.nextBool();

    if (isFixWidth) {
      if (random.nextBool()) {
        width = 0 - asteroidSide / 2;
        angle = randomAngle;
      } else {
        width = maxWidth + asteroidSide / 2;
        angle = randomAngle + pi;
      }
      height = random.nextInt(maxHeight.toInt()).toDouble();
    } else {
      if (random.nextBool()) {
        height = 0 - asteroidSide / 2;
        angle = randomAngle + pi / 2;
      } else {
        height = maxHeight + asteroidSide / 2;
        angle = randomAngle + 3 * pi / 2;
      }
      width = random.nextInt(maxWidth.toInt()).toDouble();
    }
    return EntityInitialInfo<double>(x: width, y: height, angle: angle);
  }
}
