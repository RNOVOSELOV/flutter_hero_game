import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacehero/entities/entity.dart';
import 'package:spacehero/game_core/game.dart';

class Player extends Entity {
  Player() : super(spriteName: "player", x: 50, y: 150);

  double _angle = 0;
  double _degree = 0;
  final double _speed = 3;
  bool isMovedLeft = false;
  bool isMovedRight = false;
  bool _isAcceleration = false;

  get getAngle => _angle;

  void  resetSpeed () {
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
    x+= sin(_degree * 0.0175) * _speed;
    y-= cos(_degree * 0.0175) * _speed;

    if (x < 0) x = 0;
    if (y < 0) y = 0;
    if (x > Game.screenWidth - 50) x = Game.screenWidth - 50;
    if (y > Game.screenHeight - 50) y = Game.screenHeight - 50;

    isMovedLeft = false;
    isMovedRight = false;
  }
}
