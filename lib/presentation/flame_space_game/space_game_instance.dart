import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';

class GameContainer extends StatelessWidget {
  const GameContainer._();

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: SpaceGame(bloc: context.read<SpaceGameBloc>()));
  }
}

class SpaceGameInstance {
  static SpaceGameInstance? _instance;
  final Widget _game;

  Widget get getGameWidget => _game;

  factory SpaceGameInstance.getInstance() =>
      _instance ??= SpaceGameInstance._internal();

  SpaceGameInstance._internal() : _game = const GameContainer._();
}
