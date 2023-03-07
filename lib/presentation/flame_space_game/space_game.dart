import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/entities_controllers/asteroid_controller.dart';
import 'package:spacehero/entities_controllers/black_hole_controller.dart';
import 'package:spacehero/entities_controllers/player_controller.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';

class SpaceGame extends FlameGame
    with HasCollisionDetection, PanDetector, KeyboardEvents {
  final SpaceGameBloc bloc;
  var _background = ParallaxComponent();
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

    _background = await loadParallaxComponent(
      [
        ParallaxImageData('background_1.png'),
        ParallaxImageData('background_2.png'),
      ],
      baseVelocity: Vector2(3, 0),
      velocityMultiplierDelta: Vector2(1.1, 1.0),
    );
    add(_background);

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

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);

    if (isSpace && isKeyDown) {
      bloc.add(PlayerFireEvent());
      return KeyEventResult.handled;
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
