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
          print("empty stream");
          return const SizedBox.shrink();
        }
        final type = snapshot.data!;
        if (type == GameSceneType.startGameScene) {
          return const StartScreenWidget();
        }
        return GameState(type: type).getScene.buildScene();
      },
    );
  }
}

class StartScreenWidget extends StatelessWidget {
  const StartScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GameBloc>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "SPACE ARMAGEDDON",
            style: TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 16,
          ),
          Image.asset(AppImages.rocketImage),
          const SizedBox(
            height: 16,
          ),
          TextButton(
              onPressed: () => bloc.startGame(),
              child: const Text(
                "NEW GAME",
                style: TextStyle(fontSize: 22, color: Colors.lightBlueAccent),
              )),
          TextButton(
              onPressed: () {},
              child: const Text(
                "BEST RESULTS",
                style: TextStyle(fontSize: 22, color: Colors.lightBlueAccent),
              )),
        ],
      ),
    );
  }
}
