import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
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
        Positioned(
          top: 0,
          left: 0,
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.deepOrange,
              ),
            ),
            width: Game.screenWidth / 2,
            height: Game.screenHeight,
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              child: const Center(
                child: Text(
                  "Rotate rocket area\n\n <--  SWIPE -->",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: Game.screenWidth / 2,
          child: Container(
            decoration: BoxDecoration(
                border: Border(
                    bottom: BorderSide(color: Colors.lightGreenAccent),
                    top: BorderSide(color: Colors.lightGreenAccent),
                    right: BorderSide(color: Colors.lightGreenAccent))),
            width: Game.screenWidth / 2,
            height: Game.screenHeight / 2,
            child: GestureDetector(
              onTap: _onTapSpeedArea,
              child: const Center(
                child: Text(
                  "START/STOP tap area",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          top: Game.screenHeight / 2,
          left: Game.screenWidth / 2,
          child: Container(
            width: Game.screenWidth / 2,
            height: Game.screenHeight / 2,
            child: GestureDetector(
              onTap: _onTabGunShoot,
              child: const Center(
                child: Text(
                  "Shot area",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ),
        ),
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

  void _onPanStart(DragStartDetails details) {
    _startGlobalPosition = details.globalPosition.dx;
  }

  void _onPanUpdate(DragUpdateDetails details) {
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
