import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacehero/game_core/game_bloc.dart';
import 'package:spacehero/resources/app_images.dart';
import 'package:spacehero/scenes/game_state.dart';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GameBloc>(context, listen: false);
    return StreamBuilder<GameSceneType>(
      stream: bloc.observeGameState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return const SizedBox.shrink();
        }
        final type = snapshot.data!;
        return Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  ElevatedButton (
                    onPressed: () => bloc.startLongOperation(),
                    child: Text("Start long operation async"),
                  ),
                  ElevatedButton (
                    onPressed: () => bloc.startIsolateLongOperation(),
                    child: Text("Start long operation in separated isolate"),
                  ),
                  ElevatedButton (
                    onPressed: () => bloc.startComputerLongOperation(),
                    child: Text("Start long operation computer"),
                  ),
                ],
              ),
            ),
            GameState(type: type).getScene.buildScene(),
          ],
        );
      },
    );
  }
}
