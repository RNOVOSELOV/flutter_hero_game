import 'dart:isolate';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/game_core/main_loop.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late ReceivePort _receivePort;
  late Isolate _isolateLoop;
  late Player player;

  void startIsolateLoop() async {
    _receivePort = ReceivePort();
    _isolateLoop = await Isolate.spawn(mainLoop, _receivePort.sendPort);
    _receivePort.listen((message) {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();
    player = Player();
    startIsolateLoop();
  }

  @override
  Widget build(BuildContext context) {
    player.update();
    return Stack(
      children: [
        player.build(),
      ],
    );
  }
}
