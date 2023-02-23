import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacehero/entities/entity.dart';

class Player extends Entity {
  final double screenWidth;
  final double screenHeight;

  Player({
    required this.screenWidth,
    required this.screenHeight,
  }) : super(spriteName: "player", x: 10, y: screenHeight / 2);

  final double _speed = 3;

  @override
  Widget build() {
    return Positioned(
      top: y,
      left: x,
      child: Transform.rotate(
        angle: pi/2,
        child: sprites[currentSprite],
      ),
    );
  }

  @override
  void move() {
    x++;
    if (x > screenWidth - 50) x = 10;
  }
}
