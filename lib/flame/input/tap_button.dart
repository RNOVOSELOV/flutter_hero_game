import 'dart:async';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/input.dart';
import 'package:spacehero/flame/space_game.dart';

class TapButton extends SpriteComponent with Tappable, HasGameRef<SpaceGame> {
  final VoidCallback onTapButton;
  final String spriteName;
  final Vector2 spritePosition;

  static const double buttonSide = 70;
  static const int buttonPadding = 20;
  static final Vector2 buttonSize = Vector2(buttonSide, buttonSide);

  TapButton({required this.spriteName, required this.spritePosition, required this.onTapButton})
      : super(
          anchor: Anchor.topLeft,
          size: buttonSize,
        );

  @override
  FutureOr<void> onLoad() async {
     super.onLoad();
     sprite = await gameRef.loadSprite(spriteName);
     position = spritePosition;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      onTapButton();
      return true;
    } catch (error) {
      print('TapButton: onTapDown - button error: $error');
      return false;
    }
  }
}
