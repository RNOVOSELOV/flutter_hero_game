import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/game_page/dto/invent_dto.dart';
import 'package:spacehero/presentation/widgets/control_button.dart';

class InventoryPanel extends StatefulWidget {
  const InventoryPanel({Key? key}) : super(key: key);

  @override
  State<InventoryPanel> createState() => _InventoryPanelState();
}

class _InventoryPanelState extends State<InventoryPanel> {
  InventDto inventDto = const InventDto.initial();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpaceGameBloc, SpaceGameState>(
      listenWhen: (previous, current) => current is InventChangedState,
      listener: (context, state) {
        if (state is InventChangedState) {
          inventDto = state.invent;
          setState(() {});
        }
      },
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
              delayNextTapMilliseconds: 250,
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
              imageAssetPath: 'assets/images/buttons/multi_fire.png',
              onTap: multiFireButtonClicked,
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
    );
  }

  void speedButtonClicked(BuildContext context) {
    context.read<SpaceGameBloc>().add(const PlayerSpeedEvent());
  }

  void armorButtonClicked(BuildContext context) {
    context.read<SpaceGameBloc>().add(const PlayerArmorEvent());
  }

  void fireButtonClicked(BuildContext context) {
    context.read<SpaceGameBloc>().add(const PlayerFireEvent());
  }

  void multiFireButtonClicked(BuildContext context) {
    context.read<SpaceGameBloc>().add(const PlayerMultiFireEvent());
  }

  void bombButtonClicked(BuildContext context) {
    print('Bomb button clicked');
  }
}
