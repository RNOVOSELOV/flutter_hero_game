import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';

class GameScreen extends StatelessWidget {
  const GameScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const GameWidget.controlled(gameFactory: SpaceGame.new);
  }
}
