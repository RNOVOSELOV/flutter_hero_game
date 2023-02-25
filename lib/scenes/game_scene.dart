import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:spacehero/entities/asteroid.dart';
import 'package:spacehero/entities/bullet.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/scenes/app_scene.dart';

class GameScene extends AppScene {
  late Player _player;

  final List<Widget> _touchAreas = [];
  final List<Bullet> _listBullets = [];
  final List<Asteroid> _listAsteroids = [];
  final List<Widget> _listWidgets = [];

  final random = Random(DateTime.now().millisecondsSinceEpoch);

  final double width;
  final double height;

  int _maxAsteroidCount = 0;

  double _startGlobalPosition = 0;

  GameScene({required this.width, required this.height}) {
    _player = Player(screenWidth: width, screenHeight: height);

    _touchAreas.add(RocketRotationArea(
      onPanStart: onPanStart,
      onPanEnd: onPanUpdate,
      screenHeight: height,
      screenWidth: width,
    ));
    _touchAreas.add(RocketShotArea(
      onTap: _onTabGunShoot,
      screenHeight: height,
      screenWidth: width,
    ));
    _touchAreas.add(RocketSpeedArea(
      onTap: _onTapSpeedArea,
      screenHeight: height,
      screenWidth: width,
    ));

    Timer.periodic(const Duration(seconds: 5), (timer) {
      _maxAsteroidCount++;
    });
  }

  @override
  Stack buildScene() {
    return Stack(
      children: [
        ..._listWidgets,
        _player.build(),
        ..._touchAreas,
      ],
    );
  }

  @override
  void update() {
    if (_listAsteroids.length < _maxAsteroidCount) {
      _listAsteroids.add(Asteroid(
          traectoryAngle: random.nextDouble() + random.nextInt(10),
          screenWidth: width,
          screenHeight: height,
          spriteName:
              AsteroidTypes.values.elementAt(random.nextInt(2)).typeName));
    }
    _player.update();
    _listWidgets.clear();
    _listBullets.removeWhere((bullet) => !bullet.isVisible);
    for (var bullet in _listBullets) {
      _listWidgets.add(bullet.build());
      bullet.update();
    }

    _listAsteroids.removeWhere((asteroid) => !asteroid.isVisible);
    for (var asterod in _listAsteroids) {
      _listWidgets.add(asterod.build());
      asterod.update();
    }
  }

  void onPanStart(DragStartDetails details) {
    _startGlobalPosition = details.globalPosition.dx;
  }

  void onPanUpdate(DragUpdateDetails details) {
    double updateGlobalPosition = details.globalPosition.dx;
    if (updateGlobalPosition > _startGlobalPosition) {
      _player.isMovedRight = true;
      _startGlobalPosition = updateGlobalPosition;
    }
    if (updateGlobalPosition < _startGlobalPosition) {
      _player.isMovedLeft = true;
      _startGlobalPosition = updateGlobalPosition;
    }
  }

  void _onTapSpeedArea() {
    _player.resetSpeed();
  }

  void _onTabGunShoot() {
    _listBullets.add(Bullet(
        shootAngle: _player.getAngle,
        shootPositionX: _player.x,
        shootPositionY: _player.y,
        screenHeight: height,
        screenWidth: width));
  }
}

class RocketShotArea extends StatelessWidget {
  final VoidCallback onTap;
  final double screenHeight;
  final double screenWidth;

  const RocketShotArea({
    Key? key,
    required this.onTap,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: screenHeight / 2,
      left: screenWidth / 2,
      child: SizedBox(
        width: screenWidth / 2,
        height: screenHeight / 2,
        child: GestureDetector(
          onTap: onTap,
        ),
      ),
    );
  }
}

class RocketSpeedArea extends StatelessWidget {
  final VoidCallback onTap;
  final double screenHeight;
  final double screenWidth;

  const RocketSpeedArea({
    Key? key,
    required this.onTap,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: screenWidth / 2,
      child: SizedBox(
        width: screenWidth / 2,
        height: screenHeight / 2,
        child: GestureDetector(
          onTap: onTap,
        ),
      ),
    );
  }
}

class RocketRotationArea extends StatelessWidget {
  final void Function(DragStartDetails details) onPanStart;
  final void Function(DragUpdateDetails details) onPanEnd;

  final double screenHeight;
  final double screenWidth;

  const RocketRotationArea({
    Key? key,
    required this.onPanStart,
    required this.onPanEnd,
    required this.screenHeight,
    required this.screenWidth,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: SizedBox(
        width: screenWidth / 2,
        height: screenHeight,
        child: GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanEnd,
        ),
      ),
    );
  }
}
