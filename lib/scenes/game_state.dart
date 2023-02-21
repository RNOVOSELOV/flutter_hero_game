import 'package:spacehero/scenes/app_scene.dart';
import 'package:spacehero/scenes/game_scene.dart';

class GameState {
  static final _scenes = <GameSceneType, GameState>{};

  final AppScene _scene;

  GameState._internal(this._scene);

  factory GameState(
      {required GameSceneType type, double width = 0, double height = 0}) {
    if (_scenes.containsKey(type)) {
      return _scenes[type]!;
    }
    // TODO REMOVE WHEN ALL STATES IS ADDED
    GameState state =
        GameState._internal(GameScene(width: width, height: height));
    switch (type) {
      case GameSceneType.startGameScene:
        // TODO: Handle this case.
        break;
      case GameSceneType.gameScene:
        state = GameState._internal(GameScene(width: width, height: height));
        break;
      case GameSceneType.statisticsScene:
        // TODO: Handle this case.
        break;
    }
    _scenes[type] = state;
    return state;
  }

  AppScene get getScene => _scene;
}

enum GameSceneType {
  startGameScene,
  gameScene,
  statisticsScene,
}
