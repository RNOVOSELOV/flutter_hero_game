import 'package:spacehero/elements/asteroid.dart';

class EntityMoveParameters {
  final double angle;
  final double speed;

  EntityMoveParameters({required this.angle, required this.speed});

  factory EntityMoveParameters.fromAsteroid({required Asteroid asteroid}) {
    return EntityMoveParameters(angle: asteroid.angleDirection, speed: asteroid.speed);
  }
}
