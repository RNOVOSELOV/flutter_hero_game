import 'dart:async';

import 'package:flame/components.dart';

abstract class Entity extends SpriteComponent {
  final String spriteName;
  final double screenWidth;
  final double screenHeight;
  bool _visible = true;

  bool get isVisible => _visible;

  set setVisible(bool value) => _visible = value;

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

  void animate(double dt);
}
