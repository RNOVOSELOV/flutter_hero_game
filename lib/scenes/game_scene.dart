import 'package:flutter/material.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/scenes/app_scene.dart';

class GameScene extends AppScene {
  late Player _player;
  final double width;
  final double height;

  double _startGlobalPosition = 0;

  GameScene({required this.width, required this.height}) {
    _player = Player(screenWidth: width, screenHeight: height);
  }

  @override
  Widget buildScene() {
    return _player.build();
  }

  @override
  void update() {
    _player.update();
  }
}