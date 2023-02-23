import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/isolates/main_loop.dart';
import 'package:spacehero/isolates/separated_loop.dart';
import 'package:spacehero/scenes/game_state.dart';

class GameBloc {
  ReceivePort? _receivePort;
  Isolate? _isolateLoop;

  late Player _player;

  final BehaviorSubject<GameSceneType> stateSubject = BehaviorSubject();

  Stream<GameSceneType> observeGameState() => stateSubject;

  GameBloc() {}

  void initBloc({required width, required height}) {
    _player = Player(screenWidth: width, screenHeight: height);
    GameState.screenHeight = height;
    GameState.screenWidth = width;
    stateSubject.add(GameSceneType.startGameScene);
    startGame();
  }

  void startLongOperation() {
    final startDt = DateTime.now();
    print("Start long operation as async");
    final future = Future<int>(() {
      var j = 0;
      for (int i = 0; i < 1000000000; i++) {
        j += i;
      }
      return j;
    });
    future.then((value) {
      final endDt = DateTime.now();
      final difference = endDt.difference(startDt).inMilliseconds;
      print("End long operation. Result: $value. Duration: $difference ms.");
    });
  }

  Future<void> startIsolateLongOperation() async {
    final startDt = DateTime.now();
    print("Start long operation in separated isolate");

    final port = ReceivePort();
    final iLoop = await Isolate.spawn(separatedLoop, port.sendPort);
    int j = await port.first;

    iLoop.kill(priority: Isolate.immediate);
    final endDt = DateTime.now();
    final difference = endDt.difference(startDt).inMilliseconds;
    print("End long operation. Result: $j. Duration: $difference ms.");
  }

  Future<void> startComputerLongOperation() async {
    final startDt = DateTime.now();
    print("Start long operation in computer");
    final j = await compute(computerLoop, 1000000000);
    final endDt = DateTime.now();
    final difference = endDt.difference(startDt).inMilliseconds;
    print("End long operation. Result: $j. Duration: $difference ms.");
  }

  void startGame() {
    _startIsolateLoop();
  }

  void _startIsolateLoop() async {
    final state = GameState(type: GameSceneType.gameScene);
    stateSubject.add(GameSceneType.gameScene);
    _receivePort = ReceivePort();
    _isolateLoop = await Isolate.spawn(mainLoop, _receivePort!.sendPort);
    _receivePort!.listen((message) {
      state.getScene.update();
      stateSubject.add(GameSceneType.gameScene);
    });
  }

  void dispose() {
    _receivePort?.close();
    _isolateLoop?.kill();
    stateSubject.close();
  }
}
