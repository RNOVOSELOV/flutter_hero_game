import 'package:spacehero/entities/asteroid.dart';
import 'package:spacehero/scenes/app_scene.dart';
import 'package:spacehero/scenes/game_scene.dart';
import 'package:spacehero/scenes/asteroids_scene.dart';
import 'package:tuple/tuple.dart';

class GameState {
  static Tuple2<GameSceneType, GameState>? _lastScene;

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
    if (_lastScene != null && _lastScene!.item1 == type) {
      return _lastScene!.item2;
    }
    GameState state;
    switch (type) {
      case GameSceneType.gameScene:
        state = GameState._internal(GameScene(width: _width, height: _height));
        break;
      case GameSceneType.newGameScene:
      case GameSceneType.endGameScene:
      case GameSceneType.statisticsScene:
        if (_lastScene != null) {
          state = GameState._internal(
              AsteroidsScene.withAsteroids(
                  _lastScene!.item2.getScene.getAsteroidsList,
                  width: _width, height: _height));
        } else {
          state = GameState._internal(
              AsteroidsScene(width: _width, height: _height));
        }
        break;
    }
    _lastScene = Tuple2(type, state);
    return state;
  }
}

enum GameSceneType {
  newGameScene,
  gameScene,
  endGameScene,
  statisticsScene,
}
