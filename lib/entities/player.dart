import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacehero/entities/entity.dart';

class Player extends Entity {
  final double screenWidth;
  final double screenHeight;

  Player({
    required this.screenWidth,
    required this.screenHeight,
  }) : super(spriteName: "player", x: screenWidth/2, y: screenHeight/2);

  double _angle = 0;
  double _degree = 0;
  final double _speed = 3;
  bool isMovedLeft = false;
  bool isMovedRight = false;
  bool _isAcceleration = false;

  get getAngle => _angle;

  void resetSpeed() {
    _isAcceleration = !_isAcceleration;
  }

  @override
  Widget build() {
    return Positioned(
      top: y,
      left: x,
      child: isVisible
          ? Transform.rotate(
              angle: _angle,
              child: sprites[currentSprite],
            )
          : const SizedBox(),
    );
  }

  @override
  void move() {
    if (!_isAcceleration) {
      return;
    }

    if (isMovedLeft) _degree -= 5;
    if (isMovedRight) _degree += 5;

    _angle = (_degree * pi) / 180;
    x += sin(_degree * 0.0175) * _speed;
    y -= cos(_degree * 0.0175) * _speed;

    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > screenWidth - 50) x = screenWidth - 50;
    if (y > screenHeight - 50) y = screenHeight - 50;

    isMovedLeft = false;
    isMovedRight = false;
  }
}
