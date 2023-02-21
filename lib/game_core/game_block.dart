import 'dart:isolate';
import 'package:rxdart/rxdart.dart';
import 'package:spacehero/isolates/main_loop.dart';
import 'package:spacehero/scenes/game_state.dart';

class GameBlock {
  ReceivePort? _receivePort;
  Isolate? _isolateLoop;

  double? width;
  double? height;

  final BehaviorSubject<GameSceneType> stateSubject = BehaviorSubject();

  Stream<GameSceneType> observeGameState() => stateSubject;

  GameBlock();

  void initBlock({required width, required height}) {
    this.width = width;
    this.height = height;

    stateSubject.add(GameSceneType.gameScene);
    startGame();
  }

  void startGame() {
    _startIsolateLoop();
  }

  void _startIsolateLoop() async {
    final state = GameState(type: GameSceneType.gameScene, width: width!, height: height!);
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
