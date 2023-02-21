import 'dart:isolate';
import 'package:rxdart/rxdart.dart';
import 'package:spacehero/isolates/main_loop.dart';
import 'package:spacehero/scenes/game_state.dart';

class GameBloc {
  ReceivePort? _receivePort;
  Isolate? _isolateLoop;

  final BehaviorSubject<GameSceneType> stateSubject = BehaviorSubject();

  Stream<GameSceneType> observeGameState() => stateSubject;

  GameBloc();

  void initBloc({required width, required height}) {
    GameState.screenHeight = height;
    GameState.screenWidth = width;
    stateSubject.add(GameSceneType.startGameScene);
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
