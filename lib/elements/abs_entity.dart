import 'dart:async';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';

abstract class Entity extends SpriteAnimationComponent with CollisionCallbacks {
  final double screenWidth;
  final double screenHeight;

  late double _speed;
  late final double _sideSize;

  bool _visible = true;

  bool get isVisible => _visible;

  set setVisible(bool value) => _visible = value;

  double get speed => _speed;

  set setSpeed(double value) => _speed = value;

  double get sideSize => _sideSize;

  Entity({
    required this.spriteName,
    required this.screenWidth,
    required this.screenHeight,
    int placePriority = 1,
  }) : super(priority: placePriority) {
    debugMode = true;
  }

  @override
  FutureOr<void> onLoad() {
    final sResult = super.onLoad();
    anchor = Anchor.center;
    add(CircleHitbox(
        anchor: Anchor.center, radius: size.x * 0.8 / 2, position: size / 2));
    return sResult;
  }

  void initializeCoreVariables({required double speed, required double side}) {
    _speed = speed;
    _sideSize = side;

    size = Vector2(sideSize, sideSize);
  }

  void animateEntity(double dt);

  void removeEntity() {
    setVisible = false;
  }
}
