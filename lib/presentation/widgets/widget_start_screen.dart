import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';
import 'package:spacehero/resources/app_images.dart';

class StartScreenWidget extends StatefulWidget {
  const StartScreenWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<StartScreenWidget> createState() => _StartScreenWidgetState();
}

class _StartScreenWidgetState extends State<StartScreenWidget> {
  @override
  Widget build(BuildContext context) {
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
          SizedBox(
            height: 100,
              child: Image.asset(AppImages.rocketImage, height: 100)),
          const SizedBox(
            height: 16,
          ),
          TextButton(
              onPressed: () =>
                  context.read<SpaceGameBloc>().add(GameLoadedEvent()),
              child: const Text(
                "NEW GAME",
                style: TextStyle(fontSize: 22, color: Colors.lightBlueAccent),
              )),
          TextButton(
              onPressed: () =>
                  context.read<SpaceGameBloc>().add(OpenStatisticScreenEvent()),
              child: const Text(
                "BEST RESULTS",
                style: TextStyle(fontSize: 22, color: Colors.lightBlueAccent),
              )),
        ],
      ),
    );
  }
}
