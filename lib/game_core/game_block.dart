import 'dart:isolate';
import 'package:rxdart/rxdart.dart';
import 'package:spacehero/game_core/main_loop.dart';
import 'package:spacehero/scenes/game_state.dart';

class GameBlock {
  ReceivePort? _receivePort;
  Isolate? _isolateLoop;

  final BehaviorSubject<GameState> stateSubject = BehaviorSubject();

  Stream<GameState> observeGameState() => stateSubject;

  GameBlock() {
    stateSubject.add(GameState.gamePage);
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
      state.scene.update();
      stateSubject.add(state);
    });
  }

  void dispose() {
    _receivePort?.close();
    _isolateLoop?.kill();
    stateSubject.close();
  }
}
