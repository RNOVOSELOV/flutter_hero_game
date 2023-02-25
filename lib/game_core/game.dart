import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spacehero/game_core/game_bloc.dart';
import 'package:spacehero/game_core/models/game_info.dart';
import 'package:spacehero/resources/app_images.dart';
import 'package:spacehero/game_core/game_core_helpers/game_state.dart';

class Game extends StatelessWidget {
  const Game({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GameBloc>(context, listen: false);
    return StreamBuilder<GameInfo>(
      stream: bloc.observeGameInfo(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          print("empty stream");
          return const SizedBox.shrink();
        }
        final gameInfo = snapshot.data!;
        switch (gameInfo.gsType) {
          case GameSceneType.newGameScene:
            return GameState(type: gameInfo.gsType).getScene.buildScene()
              ..children.add(const StartScreenWidget());
          case GameSceneType.gameScene:
            return GameState(type: gameInfo.gsType).getScene.buildScene()
              ..children.add(Positioned(
                  top: 10,
                  left: 10,
                  child: Text(
                    "Score: ${gameInfo.score}",
                    style: const TextStyle(fontSize: 20),
                  )));
          case GameSceneType.endGameScene:
            return GameState(type: gameInfo.gsType).getScene.buildScene()
              ..children.add(EndGameWidget(scoreValue: gameInfo.score));
          case GameSceneType.statisticsScene:
            print("GameSceneType.statisticsScene");
            return const SizedBox.shrink();
        }
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

class EndGameWidget extends StatelessWidget {
  final int scoreValue;

  const EndGameWidget({
    Key? key,
    required this.scoreValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GameBloc>(context, listen: false);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "You result: $scoreValue",
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(
            height: 16,
          ),
          TextButton(
              onPressed: () => bloc.openFirstPage(),
              child: const Text(
                "OPEN START PAGE",
                style: TextStyle(fontSize: 22, color: Colors.lightBlueAccent),
              )),
        ],
      ),
    );
  }
}
