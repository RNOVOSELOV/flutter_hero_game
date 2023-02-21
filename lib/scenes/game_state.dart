import 'package:spacehero/scenes/app_scene.dart';
import 'package:spacehero/scenes/game_scene.dart';

class GameState {
  static final _scenes = <GameSceneType, GameState>{};

  static double _width = 0;
  static double _height = 0;

  static set screenHeight(double height) => _height = height;

  static set screenWidth(double width) => _width = width;

  final AppScene _scene;

  AppScene get getScene => _scene;

  GameState._internal(this._scene);

  factory GameState({
    required GameSceneType type,
  }) {
    if (_scenes.containsKey(type)) {
      return _scenes[type]!;
    }
    GameState state;
    switch (type) {
      case GameSceneType.startGameScene:
        state = GameState._internal(GameScene(width: _width, height: _height));
        break;
      case GameSceneType.gameScene:
        state = GameState._internal(GameScene(width: _width, height: _height));
        break;
      case GameSceneType.statisticsScene:
        state = GameState._internal(GameScene(width: _width, height: _height));
        break;
    }
    _scenes[type] = state;
    return state;
  }
}

enum GameSceneType {
  startGameScene,
  gameScene,
  statisticsScene,
}
