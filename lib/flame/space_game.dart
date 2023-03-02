import 'dart:async';

import 'package:flame/components.dart' hide Timer;
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacehero/elements/abs_entity.dart';
import 'package:spacehero/elements/asteroid.dart';
import 'package:spacehero/elements/black_hole.dart';
import 'package:spacehero/elements/bullet.dart';
import 'package:spacehero/flame/input/tap_button.dart';
import 'package:spacehero/elements/player.dart';

class SpaceGame extends FlameGame with HasTappables, PanDetector, HasCollisionDetection {
  final _background = SpriteComponent();
  final TextPaint scoreText = TextPaint(
      style: GoogleFonts.pressStart2p(fontSize: 16, color: Colors.white60));
  final entities = <Entity>[];

  late final TapButton _fireButton;
  late final TapButton _frizzButton;
  late final TapButton _speedButton;
  late final Player _player;


  late final double _screenWidth;
  late final double _screenHeight;

  int _maxAsteroidCount = 1;
  int score = 0;

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

    add(_fireButton);
//    add(_frizzButton);
//    add(_speedButton);

    add(_player);

    Timer.periodic(
      const Duration(seconds: 5),
      (_) => _maxAsteroidCount++,
    );


    Timer.periodic(
      const Duration(seconds: 15),
      (_) => blackHoleManager(),
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    scoreText.render(canvas, 'Score: $score', Vector2(10, 10));
  }

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

  void removeMarkedEntities() {
    entities.removeWhere((element) {
      if (!element.isVisible) {
        remove(element);
        return true;
      }
      return false;
    });
  }

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
      Entity blackHole = BlackHole(
        spriteName: 'black_hole.png',
        screenWidth: _screenWidth,
        screenHeight: _screenHeight,
      );
      entities.add(blackHole);
      await add(blackHole);
    }
  }

  Future<void> manageEntities(double dt) async {
    if (entities.length < _maxAsteroidCount) {
      Entity asteroid = Asteroid(
          spriteName: AsteroidHelper.getAsteroidSpriteName(),
          screenWidth: _screenWidth,
          screenHeight: _screenHeight);
      entities.add(asteroid);
      await add(asteroid);
    }
    for (Entity entity in entities) {
      entity.animateEntity(dt);
      if (entity.x > _screenWidth + entity.size[0] ||
          entity.y > _screenHeight + entity.size[0] ||
          entity.x < 0 - entity.size[0] ||
          entity.y < 0 - entity.size[0]) {
        entity.removeEntity();
      }
    }
  }

  Future<void> createBullet() async {
    Entity bullet = Bullet(
        spriteName: 'bullet3.png',
        screenWidth: _screenWidth,
        screenHeight: _screenHeight,
        shootAngle: _player.angle,
        startPositionX: _player.position.x,
        startPositionY: _player.position.y);
    entities.add(bullet);

    await add(bullet);
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    _player.rotate(dx: info.raw.delta.dx);
  }

  void onFireButtonTapped() {
    createBullet();
  }

  void onFrizzButtonTapped() {
    print("Frizz!");
  }

  void onSpeedButtonTapped() {
    print("Speed!");
  }
}
