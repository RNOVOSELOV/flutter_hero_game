import 'dart:async';

import 'package:flame/components.dart';

abstract class Entity extends SpriteComponent {
  final String spriteName;
  final double screenWidth;
  final double screenHeight;

  late final double _speed;
  late final double _sideSize;

  bool _visible = true;

  bool get isVisible => _visible;

  set setVisible(bool value) => _visible = value;

  double get speed => _speed;

  double get sideSize => _sideSize;

  double get angleDirection;

  Entity({
    required this.spriteName,
    required this.screenWidth,
    required this.screenHeight,
  });

  @override
  FutureOr<void> onLoad() {
    final sResult = super.onLoad();
    anchor = Anchor.center;
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
