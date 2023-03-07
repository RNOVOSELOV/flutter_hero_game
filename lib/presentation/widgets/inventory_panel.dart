import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/space_game/dto/invent_dto.dart';
import 'package:spacehero/presentation/widgets/control_button.dart';

class InventoryPanel extends StatefulWidget {
  const InventoryPanel({Key? key}) : super(key: key);

  @override
  State<InventoryPanel> createState() => _InventoryPanelState();
}

class _InventoryPanelState extends State<InventoryPanel> {
  InventDto inventDto = const InventDto.initial();
  double opacity = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpaceGameBloc, SpaceGameState>(
      listenWhen: (previous, current) =>
          current is InventChangedState ||
          current is SpaceGameInitialState ||
          current is SpaceGameStatusChanged,
      listener: (context, state) {
        if (state is InventChangedState) {
          inventDto = state.invent;
          setState(() {});
        } else if (state is SpaceGameStatusChanged) {
          switch (state.status) {
            case GameStatus.initial:
            case GameStatus.gameOver:
            case GameStatus.statistics:
              opacity = 0;
              setState(() {});
              break;
            case GameStatus.respawn:
            case GameStatus.respawned:
              opacity = 1;
              setState(() {});
              break;
          }
        } else if (state is SpaceGameInitialState) {
          opacity = 0;
          setState(() {});
        }
        print('_InventoryPanelState state changed $inventDto');
      },
      child: Opacity(
        opacity: opacity,
        child: Align(
          alignment: Alignment.centerRight,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              const SizedBox(
                height: 24,
              ),
              const Spacer(),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/speed.png',
                onTap: speedButtonClicked,
                delayNextTapMilliseconds: 1000,
                value: inventDto.speed,
              ),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/armor.png',
                onTap: armorButtonClicked,
                delayNextTapMilliseconds: 2000,
                value: inventDto.armor,
              ),
              const Spacer(),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/fire.png',
                onTap: fireButtonClicked,
                delayNextTapMilliseconds: 250,
                value: inventDto.rocket,
              ),
              ControlButton(
                imageAssetPath: 'assets/images/buttons/bomb.png',
                onTap: bombButtonClicked,
                delayNextTapMilliseconds: 4000,
                value: inventDto.bomb,
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  void speedButtonClicked(BuildContext context) {
    print('Speed button clicked');
  }

  void armorButtonClicked(BuildContext context) {
    print('Armor button clicked');
  }

  void fireButtonClicked(BuildContext context) {
    context.read<SpaceGameBloc>().add(PlayerFireEvent());
    print('Fire button clicked');
  }

  void bombButtonClicked(BuildContext context) {
    print('Bomb button clicked');
  }
}
