import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:spacehero/elements/asteroid.dart';
import 'package:spacehero/flame/input/tap_button.dart';
import 'package:spacehero/elements/player.dart';

import '../elements/abs_entity.dart';

class SpaceGame extends FlameGame with HasTappables, PanDetector {
  final _background = SpriteComponent();
  late final TapButton _fireButton;
  late final TapButton _frizzButton;
  late final TapButton _speedButton;
  late final Player _player;

  final entities = <Entity>[];
  late final double _screenWidth;
  late final double _screenHeight;

  int _maxAsteroidCount = 1;

  @override
  Future<void> onLoad() async {
    super.onLoad();
    _screenWidth = size[0];
    _screenHeight = size[1];
    _player = Player(
        spriteName: 'player0.png',
        screenWidth: _screenWidth,
        screenHeight: _screenHeight);

    _fireButton = TapButton(
        spriteName: 'button_fire.png',
        spritePosition: Vector2(
            _screenWidth -
                TapButton.buttonPadding * 2 -
                TapButton.buttonSide * 2,
            _screenHeight - TapButton.buttonPadding - TapButton.buttonSide),
        onTapButton: onFireButtonTapped);
    _frizzButton = TapButton(
        spriteName: 'button_frizz.png',
        spritePosition: Vector2(
            _screenWidth - TapButton.buttonPadding - TapButton.buttonSide,
            _screenHeight - TapButton.buttonPadding - TapButton.buttonSide),
        onTapButton: onFrizzButtonTapped);
    _speedButton = TapButton(
        spriteName: 'button_speed.png',
        spritePosition: Vector2(
            _screenWidth - TapButton.buttonPadding - TapButton.buttonSide,
            TapButton.buttonPadding.toDouble()),
        onTapButton: onSpeedButtonTapped);

    add(_background
      ..sprite = await loadSprite('background.png')
      ..size = size);

//    add(_fireButton);
//    add(_frizzButton);
//    add(_speedButton);

    add(_player);

    final timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _maxAsteroidCount++,
    );
  }

  // TODO заменить на изолят
  @override
  void update(double dt) {
    super.update(dt);

    _player.animate(dt);

    entities.removeWhere((element) {
      if (!element.isVisible) {
        remove(element);
        return true;
      }
      return false;
    });

    checkEntityCount(dt);
  }

  Future<void> checkEntityCount(double dt) async {
    if (entities.length < _maxAsteroidCount) {
      Entity asteroid = Asteroid(
          spriteName: AsteroidHelper.getAsteroidSpriteName(),
          screenWidth: _screenWidth,
          screenHeight: _screenHeight);
      entities.add(asteroid);
      await add(asteroid);
    }

    for (Entity entity in entities) {
      entity.animate(dt);
      if (entity.x > _screenWidth + entity.size[0] ||
          entity.y > _screenHeight + entity.size[0] ||
          entity.x < 0 - entity.size[0] ||
          entity.y < 0 - entity.size[0]) {
        entity.setVisible = false;
      }
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.rotate(dx: info.raw.delta.dx);
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
