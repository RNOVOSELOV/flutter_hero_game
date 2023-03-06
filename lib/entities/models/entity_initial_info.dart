import 'package:flame/game.dart';

class EntityInitialInfo {
  final Vector2 position;
  final double? angle;

  EntityInitialInfo({required double x, required double y, this.angle})
      : position = Vector2(x, y);
}
