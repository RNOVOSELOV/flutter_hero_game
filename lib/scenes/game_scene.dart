import 'package:flutter/material.dart';
import 'package:spacehero/entities/bullet.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/game_core/game.dart';
import 'package:spacehero/scenes/app_scene.dart';

class GameScene extends AppScene {
  final Player _player = Player();
  List<Bullet> _listBullets = [];
  List<Widget> _listWidgets = [];

  double _startGlobalPosition = 0;

  GameScene();

  @override
  Widget buildScene() {
    return Stack(
      children: [
        _player.build(),
        RocketRotationArea(onPanStart: onPanStart, onPanEnd: onPanUpdate),
        RocketSpeedArea(onTap: _onTapSpeedArea),
        RocketShotArea(onTap: _onTabGunShoot),
        ..._listWidgets,
      ],
    );
  }

  @override
  void update() {
    _player.update();
    _listWidgets.clear();
    _listBullets.removeWhere((bullet) => !bullet.isVisible);
    for (var bullet in _listBullets) {
        _listWidgets.add(bullet.build());
      bullet.update();
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
        shootPositionY: _player.y));
  }
}

class RocketShotArea extends StatelessWidget {
  final VoidCallback onTap;

  const RocketShotArea({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: Game.screenHeight / 2,
      left: Game.screenWidth / 2,
      child: SizedBox(
        width: Game.screenWidth / 2,
        height: Game.screenHeight / 2,
        child: GestureDetector(
          onTap: onTap,
        ),
      ),
    );
  }
}

class RocketSpeedArea extends StatelessWidget {
  final VoidCallback onTap;

  const RocketSpeedArea({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: Game.screenWidth / 2,
      child: SizedBox(
        width: Game.screenWidth / 2,
        height: Game.screenHeight / 2,
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

  const RocketRotationArea({
    Key? key,
    required this.onPanStart,
    required this.onPanEnd,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      child: SizedBox(
        width: Game.screenWidth / 2,
        height: Game.screenHeight,
        child: GestureDetector(
          onPanStart: onPanStart,
          onPanUpdate: onPanEnd,
        ),
      ),
    );
  }
}
