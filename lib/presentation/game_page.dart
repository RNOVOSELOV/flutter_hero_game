import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';
import 'package:spacehero/presentation/widgets/inventory_panel.dart';

class GamePage extends StatelessWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocProvider(
        create: (context) => SpaceGameBloc(screenSize: size),
        child: const GameView(),
      ),
    );
  }
}

class GameView extends StatelessWidget {
  const GameView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: [
        Positioned.fill(child: Game()),
        InventoryPanel(),
      ],
    );
  }
}

class Game extends StatelessWidget {
  const Game({super.key});

  @override
  Widget build(BuildContext context) {
    return GameWidget(game: SpaceGame(bloc: context.read<SpaceGameBloc>()));
  }
}
