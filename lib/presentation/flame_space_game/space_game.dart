import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/entities_controllers/asteroid_controller.dart';
import 'package:spacehero/entities_controllers/black_hole_controller.dart';
import 'package:spacehero/entities_controllers/player_controller.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';

class SpaceGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, PanDetector {
  final SpaceGameBloc bloc;
  final _background = SpriteComponent();
  Player? player;

  late final double _screenWidth;
  late final double _screenHeight;

  double get getScreenWidth => _screenWidth;

  double get getScreenHeight => _screenHeight;

  SpaceGame({required this.bloc});

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _screenWidth = size[0];
    _screenHeight = size[1];

    add(_background
      ..sprite = await loadSprite('background.png')
      ..size = size);

    await add(FlameBlocProvider<SpaceGameBloc, SpaceGameState>.value(
      value: bloc,
      children: [
        PlayerController(),
        BlackHoleController(),
        AsteroidController(),
      ],
    ));
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    if (player != null) {
      player!.rotate(dx: info.raw.delta.dx);
    }
  }

/*

  @override
  void update(double dt) {
    super.update(dt);

    if (!_player.isVisible) {
      print('Emd game !!!');
      _player.setVisible = true;
    }
    removeMarkedEntities();
    manageEntities(dt);
  }
*/
}
