import 'package:flutter/material.dart';
import 'package:spacehero/game_core/game_block.dart';
import 'package:spacehero/scenes/game_state.dart';

class Game extends StatefulWidget {
  const Game({Key? key}) : super(key: key);

  @override
  State<Game> createState() => _GameState();
}

class _GameState extends State<Game> {
  late GameBlock block;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      block = GameBlock(height: screenHeight, width: screenWidth);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<GameState>(
      stream: block.observeGameState(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          print("empty stream");
          return const SizedBox.shrink();
        }
        final GameState state = snapshot.data!;
        return state.getScene.buildScene();
      },
    );
  }

  @override
  void dispose() {
    block.dispose();
    super.dispose();
  }
}
