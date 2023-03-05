import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/entities_controllers/asteroid_controller.dart';
import 'package:spacehero/entities_controllers/black_hole_controller.dart';
import 'package:spacehero/entities_controllers/player_controller.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';

class SpaceGame extends FlameGame
    with HasCollisionDetection, HasKeyboardHandlerComponents, PanDetector {
  final SpaceGameBloc bloc;
  final _background = SpriteComponent();
  late final Player player;

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
        player = Player(gameplayArea: size),
        PlayerController(),
      ],
    ));

    add(BlackHoleController());
    add(AsteroidController());
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    player.rotate(dx: info.raw.delta.dx);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
//    scoreText.render(canvas, 'Score: $score', Vector2(10, 10));
  }

/*
// TODO заменить на изолят
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
/*

  FutureOr<void> blackHoleManager() async {
    bool blackHoleIsPresent = false;
    for (Entity entity in entities) {
      if (entity is BlackHole) {
        blackHoleIsPresent = true;
        entity.removeEntity();
        _maxAsteroidCount--;
      }
    }
    if (!blackHoleIsPresent) {
      _maxAsteroidCount++;
      Entity blackHole = BlackHole();
      entities.add(blackHole);
      await add(blackHole);
    }
  }

  Future<void> manageEntities(double dt) async {
    if (entities.length < _maxAsteroidCount) {
      //     Entity asteroid =
      //         Asteroid();
      //     entities.add(asteroid);
      //     await add(asteroid);
    }
    for (Entity entity in entities) {
      entity.animateEntity(dt);
      if (entity.x > _screenWidth + entity.size[0] ||
          entity.y > _screenHeight + entity.size[0] ||
          entity.x < 0 - entity.size[0] ||
          entity.y < 0 - entity.size[0]) {
//        entity.removeEntity();
      }
    }
  }




 */
}
