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
    GameState state;
    switch (type) {
      case GameSceneType.startGameScene:
        state = GameState._internal(GameScene(width: width, height: height));
        break;
      case GameSceneType.gameScene:
        state = GameState._internal(GameScene(width: width, height: height));
        break;
      case GameSceneType.statisticsScene:
        state = GameState._internal(GameScene(width: width, height: height));
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
