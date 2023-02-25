import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacehero/entities/asteroid.dart';
import 'package:spacehero/scenes/app_scene.dart';

class AsteroidsScene extends AppScene {
  final List<Asteroid> _listAsteroids = [];
  final List<Widget> _listWidgets = [];

  final double width;
  final double height;

  int _maxAsteroidCount = 0;

  @override
  get getAsteroidsList => _listAsteroids;

  AsteroidsScene({required this.width, required this.height}) {
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _maxAsteroidCount++;
    });
  }

  AsteroidsScene.withAsteroids (List<Asteroid> asteroids, {required this.width, required this.height}) {
    _listAsteroids.addAll(asteroids);
    _maxAsteroidCount = _listAsteroids.length;
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _maxAsteroidCount++;
    });
  }

  @override
  Stack buildScene() {
    return Stack(
      children: [
        ..._listWidgets,
      ],
    );
  }

  @override
  void update() {
    if (_listAsteroids.length < _maxAsteroidCount) {
      final random = Random(DateTime.now().millisecondsSinceEpoch);
      _listAsteroids.add(Asteroid(
          traectoryAngle: random.nextDouble() + random.nextInt(10),
          screenWidth: width,
          screenHeight: height,
          spriteName:
              AsteroidTypes.values.elementAt(random.nextInt(1)).typeName));
    }
    _listWidgets.clear();
    _listAsteroids.removeWhere((asteroid) => !asteroid.isVisible);
    for (var asteroid in _listAsteroids) {
      _listWidgets.add(asteroid.build());
      asteroid.update();
    }
  }
}
