import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacehero/entities/entity.dart';

class Asteroid extends Entity {
  final double traectoryAngle;
  final double _speed = 5;

  final double screenWidth;
  final double screenHeight;

  Asteroid({
    required this.traectoryAngle,
    required this.screenWidth,
    required this.screenHeight,
    required String spriteName,
  }) : super(
          spriteName: spriteName,
        ) {
    final coordinate = getRandomStartValue(screenWidth, screenHeight);
    x = coordinate.x;
    y = coordinate.y;
  }

  @override
  Widget build() {
    return Positioned(
      top: y,
      left: x,
      child: Transform.rotate(
        angle: traectoryAngle,
        child: sprites[currentSprite],
      ),
    );
  }

  @override
  void move() {
    x += sin(traectoryAngle) * _speed;
    y -= cos(traectoryAngle) * _speed;

    if (x > screenWidth || y > screenHeight || x < 0 || y < 0) {
      visible = false;
    }
  }

  Coordinate<double> getRandomStartValue(double maxWidth, double maxHeight) {
    double width = 0;
    double height = 0;
    final random = Random(DateTime.now().millisecondsSinceEpoch);
    final isFixWidth = random.nextBool();

    if (isFixWidth) {
      if (random.nextBool()) {
        width = 0;
      } else {
        width = maxWidth - 1;
      }
      height = random.nextInt(maxHeight.toInt()).toDouble();
    }
    else {
      if (random.nextBool()) {
        height = 0;
      } else {
        height = maxHeight - 1;
      }
      width = random.nextInt(maxWidth.toInt()).toDouble();
    }
    return Coordinate<double>(x: width, y: height);
  }
}

class AsteroidTypes {
  final String typeName;

  const AsteroidTypes._(this.typeName);

  static const brown = AsteroidTypes._("asteroidbig");
  static const white = AsteroidTypes._("asteroidwhite");

  static const values = [brown, white];

  @override
  String toString() {
    return typeName;
  }
}

class Coordinate<T> {
  final T x;
  final T y;

  Coordinate({required this.x, required this.y});
}
