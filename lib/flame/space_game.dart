import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:spacehero/flame/input/tap_button.dart';
import 'package:spacehero/flame/player.dart';

class SpaceGame extends FlameGame with HasTappables, PanDetector {
  final _background = SpriteComponent();

  late final TapButton _fireButton;
  late final TapButton _frizzButton;
  late final TapButton _speedButton;
  final Player _player = Player();

  @override
  Future<void> onLoad() async {
    super.onLoad();

    final screenWidth = size[0];
    final screenHeight = size[1];

    _fireButton = TapButton(
        spriteName: 'button_fire.png',
        spritePosition: Vector2(
            screenWidth -
                TapButton.buttonPadding * 2 -
                TapButton.buttonSide * 2,
            screenHeight - TapButton.buttonPadding - TapButton.buttonSide),
        onTapButton: onFireButtonTapped);
    _frizzButton = TapButton(
        spriteName: 'button_frizz.png',
        spritePosition: Vector2(
            screenWidth - TapButton.buttonPadding - TapButton.buttonSide,
            screenHeight - TapButton.buttonPadding - TapButton.buttonSide),
        onTapButton: onFrizzButtonTapped);
    _speedButton = TapButton(
        spriteName: 'button_speed.png',
        spritePosition: Vector2(
            screenWidth - TapButton.buttonPadding - TapButton.buttonSide,
            TapButton.buttonPadding.toDouble()),
        onTapButton: onSpeedButtonTapped);

    add(_background
      ..sprite = await loadSprite('background.png')
      ..size = size);

    add(_player);

    add(_fireButton);
    add(_frizzButton);
    add(_speedButton);
  }

  @override
  void update(double dt) {
    super.update(dt);
    _player.move(); // TODO заменить на изолят
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.rotate(info.raw.delta.dx);
  }

  void onFireButtonTapped() {
    print("Fire!");
  }

  void onFrizzButtonTapped() {
    print("Frizz!");
  }

  void onSpeedButtonTapped() {
    print("Speed!");
  }
}
