import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacehero/entities/entity.dart';
import 'package:spacehero/game_core/game.dart';

class Bullet extends Entity {
  final double shootAngle;
  final double _speed = 6;

  Bullet(
      {required this.shootAngle,
      required shootPositionX,
      required shootPositionY})
      : super(
          spriteName: "bullet",
          x: shootPositionX,
          y: shootPositionY,
        );

  @override
  Widget build() {
    return Positioned(
      top: y,
      left: x,
      child: Transform.rotate(
        angle: shootAngle,
        child: sprites[currentSprite],
      ),
    );
  }

  @override
  void move() {
    x += sin(shootAngle) * _speed;
    y -= cos(shootAngle) * _speed;

    if (x > Game.screenWidth || y > Game.screenHeight || x < 0 || y < 0) {
      visible = false;
    }
  }
}
