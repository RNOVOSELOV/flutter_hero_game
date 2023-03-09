import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/entities/models/entity_initial_info.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class AsteroidController extends TimerComponent with HasGameRef<SpaceGame> {
  AsteroidController()
      : super(
            period: AppConstants.asteroidGenerationTimeInSeconds, repeat: true);

  @override
  void onTick() {
//    parent?.add(Asteroid(gameplayArea: gameRef.size));
//    print('Asteroid timer ticked! Elements: ${parent?.children.whereType<Asteroid>().toList().length}');
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

  static EntityInitialInfo getAsteroidStartPositionValue({
    required double maxWidth,
    required double maxHeight,
    required double asteroidSide,
  }) {
    final random = Random(DateTime.now().microsecond);
    final isFixX = random.nextBool();
    double randomAngle = random.nextDouble() * pi;

    double newX = 0;
    double newY = 0;

    if (isFixX) {
      if (random.nextBool()) {
        newX = 0 - asteroidSide / 2;
      } else {
        newX = maxWidth + asteroidSide / 2;
        randomAngle += pi;
      }
      newY = random.nextInt(maxHeight.toInt()).toDouble();
    } else {
      if (random.nextBool()) {
        newY = 0 - asteroidSide / 2;
        randomAngle += pi / 2;
      } else {
        newY = maxHeight + asteroidSide / 2;
        randomAngle += 3 * pi / 2;
      }
      newX = random.nextInt(maxWidth.toInt()).toDouble();
    }
    return EntityInitialInfo(x: newX, y: newY, angle: randomAngle);
  }
}
