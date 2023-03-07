import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';

class EndGameWidget extends StatelessWidget {
  final int scoreValue;

  const EndGameWidget({
    Key? key,
    required this.scoreValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              onPressed: () =>
                  context.read<SpaceGameBloc>().add(OpenInitialScreenEvent()),
              child: const Text(
                "OPEN START PAGE",
                style: TextStyle(fontSize: 22, color: Colors.lightBlueAccent),
              )),
        ],
      ),
    );
  }
}
