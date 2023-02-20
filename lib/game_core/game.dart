import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:spacehero/game_core/main_loop.dart';
import 'package:spacehero/scenes/app_scene.dart';
import 'package:spacehero/scenes/game_scene.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  static AppScene currentScene = GameScene();
  static double screenWidth = 0;
  static double screenHeight = 0;

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  final ReceivePort _receivePort = ReceivePort();
  late final Isolate _isolateLoop;

  void _startIsolateLoop() async {
    _isolateLoop = await Isolate.spawn(mainLoop, _receivePort.sendPort);
    _receivePort.listen((message) {
      Game.currentScene.update();
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    _startIsolateLoop();

    print("MediaQuery ${Game.screenHeight} ${Game.screenWidth}");
  }

  @override
  Widget build(BuildContext context) {
    return Game.currentScene.buildScene();
  }

  @override
  void dispose() {
    _receivePort.close();
    _isolateLoop.kill();
    super.dispose();
  }
}
