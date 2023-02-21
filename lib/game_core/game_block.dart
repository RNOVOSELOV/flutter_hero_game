import 'dart:isolate';
import 'package:rxdart/rxdart.dart';
import 'package:spacehero/game_core/main_loop.dart';
import 'package:spacehero/scenes/game_state.dart';

class GameBlock {
  ReceivePort? _receivePort;
  Isolate? _isolateLoop;

  final double width;
  final double height;

  final BehaviorSubject<GameState> stateSubject = BehaviorSubject();

  Stream<GameState> observeGameState() => stateSubject;

  GameBlock({required this.width, required this.height}) {
    stateSubject.add(GameState(type: GameSceneType.gameScene, height: height, width: width));
    startGame();
  }

  void startGame() {
    _startIsolateLoop();
  }

  void _startIsolateLoop() async {
    final state = stateSubject.value;
    _receivePort = ReceivePort();
    _isolateLoop = await Isolate.spawn(mainLoop, _receivePort!.sendPort);
    _receivePort!.listen((message) {
      state.getScene.update();
      stateSubject.add(state);
    });
  }

  void dispose() {
    _receivePort?.close();
    _isolateLoop?.kill();
    stateSubject.close();
  }
}
