import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:spacehero/data/models/game_result.dart';
import 'package:spacehero/data/repositories/results_repository.dart';
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
            return GameState(type: gameInfo.gsType).getScene.buildScene()
              ..children.add(const BestResultsWidget());
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
              onPressed: () => bloc.openStatisticsPage(),
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
            "YOU RESULT: $scoreValue",
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

class BestResultsWidget extends StatelessWidget {
  const BestResultsWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<GameBloc>(context, listen: false);

    return StreamBuilder<List<Result>>(
        stream: ResultsRepository.getInstance().observeItems(),
        builder: (context, snapshot) {
          String title = "EMPTY STATISTIC LIST";
          List<Widget> result = [];
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            print("empty result stream");
          } else {
            title = "BEST RESULTS";
            result = snapshot.data!
                .map((e) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                      "${e.score} - ${DateFormat('dd MMM yyyy').format(e.dt)}", style: const TextStyle(fontSize: 14),),
                ))
                .toList();
          }
          print("BestResultsWidget ${snapshot.data}");
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 32),
                ),
                const SizedBox(
                  height: 16,
                ),
                ...result,
                const SizedBox(
                  height: 16,
                ),
                TextButton(
                    onPressed: () => bloc.openFirstPage(),
                    child: const Text(
                      "OPEN START PAGE",
                      style: TextStyle(
                          fontSize: 22, color: Colors.lightBlueAccent),
                    )),
              ],
            ),
          );
        });
  }
}
