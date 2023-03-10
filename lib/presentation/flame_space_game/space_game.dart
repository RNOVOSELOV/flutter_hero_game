import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame/parallax.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/entities_controllers/asteroid_controller.dart';
import 'package:spacehero/entities_controllers/black_hole_controller.dart';
import 'package:spacehero/entities_controllers/bonus_controller.dart';
import 'package:spacehero/entities_controllers/player_controller.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';

class SpaceGame extends FlameGame
    with HasCollisionDetection, KeyboardEvents, HasDraggables {
  final SpaceGameBloc bloc;
  var _background = ParallaxComponent();
  Player? player;

  late JoystickComponent joystick;

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
      baseVelocity: Vector2(2, 0),
      velocityMultiplierDelta: Vector2(1.1, 1.0),
    );
    add(_background);

    joystick = JoystickComponent(
      knob: CircleComponent(
          radius: 20, paint: BasicPalette.darkGray.withAlpha(200).paint()),
      background: CircleComponent(
          radius: 60, paint: BasicPalette.darkGray.withAlpha(80).paint()),
      margin: const EdgeInsets.only(left: 30, bottom: 30),
    )..anchor = Anchor.center;

    await add(FlameBlocProvider<SpaceGameBloc, SpaceGameState>.value(
      value: bloc,
      children: [
        PlayerController(),
        BlackHoleController(),
        AsteroidController(),
        BonusController(),
      ],
    ));
  }

  @override
  KeyEventResult onKeyEvent(
      RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    final isKeyDown = event is RawKeyDownEvent;

    if (isKeyDown) {
      if (keysPressed.contains(LogicalKeyboardKey.keyA)) {
        bloc.add(const PlayerArmorEvent());
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyS)) {
        bloc.add(const PlayerSpeedEvent());
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyZ)) {
        bloc.add(const PlayerFireEvent());
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyX)) {
        bloc.add(const PlayerMultiFireEvent());
        return KeyEventResult.handled;
      } else if (keysPressed.contains(LogicalKeyboardKey.keyC)) {
        bloc.add(const PlayerBombFireEvent());
        return KeyEventResult.handled;
      }
    }
    return super.onKeyEvent(event, keysPressed);
  }
}
