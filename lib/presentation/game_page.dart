import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';

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
    return Stack(
      children: [
        const Positioned.fill(child: Game()),
        Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const Spacer(),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/speed.png',
                onTap: speedButtonClicked,
                delayNextTapMilliseconds: 1000,
              ),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/armor.png',
                onTap: armorButtonClicked,
                delayNextTapMilliseconds: 2000,
              ),
              const Spacer(),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/fire.png',
                onTap: fireButtonClicked,
                delayNextTapMilliseconds: 3000,
              ),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/bomb.png',
                onTap: bombButtonClicked,
                delayNextTapMilliseconds: 4000,
              ),
              const Spacer(),
            ],
          ),
        ),
//          Positioned(top: 50, right: 10, child: Inventory()), score and lives area
//          add shoot, defend and speed area
      ],
    );
  }

  void speedButtonClicked() {
    print('Speed button clicked');
  }

  void armorButtonClicked() {
    print('Armor button clicked');
  }

  void fireButtonClicked() {
    print('Fire button clicked');
  }

  void bombButtonClicked() {
    print('Bomb button clicked');
  }
}

class ControlButton extends StatefulWidget {
  final VoidCallback onTap;
  final String imageAssetPath;
  final int delayNextTapMilliseconds;

  const ControlButton({
    super.key,
    required this.onTap,
    required this.imageAssetPath,
    required this.delayNextTapMilliseconds,
  });

  @override
  State<ControlButton> createState() => _ControlButtonState();
}

class _ControlButtonState extends State<ControlButton> {
  bool _active = true;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_active) {
          widget.onTap();
        }
        setState(() {
          _active = false;
        });
        Future.delayed(
          Duration(milliseconds: widget.delayNextTapMilliseconds),
          () {
            setState(() {
              _active = true;
            });
          },
        );
      },
      child: Container(
        clipBehavior: Clip.hardEdge,
        margin: const EdgeInsets.only(right: 12, top: 12),
        width: 60,
        height: 60,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white24,
        ),
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            _active ? Colors.transparent : Colors.grey,
            BlendMode.saturation,
          ),
          child: Image.asset(widget.imageAssetPath),
        ),
      ),
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
