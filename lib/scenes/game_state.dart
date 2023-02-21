import 'package:spacehero/scenes/app_scene.dart';
import 'package:spacehero/scenes/game_scene.dart';

class GameState {
  final AppScene scene;

  GameState._(this.scene);

  static final startGamePage = GameState._(GameScene());
  static final gamePage = GameState._(GameScene());
  static final statisticsPage = GameState._(GameScene());


}
