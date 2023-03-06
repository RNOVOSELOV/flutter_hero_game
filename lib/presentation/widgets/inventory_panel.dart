import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/space_game/dto/invent_dto.dart';
import 'package:spacehero/presentation/widgets/control_button.dart';

class InventoryPanel extends StatelessWidget {
  const InventoryPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<InventDto>(
        stream: BlocProvider.of<SpaceGameBloc>(context).observeInvent(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data == null) {
            return const SizedBox.shrink();
          }
          final info = snapshot.data!;
          return Align(
            alignment: Alignment.centerRight,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                const Spacer(),
                ControlButton(
                  imageAssetPath: 'assets/images/buttons/speed.png',
                  onTap: speedButtonClicked,
                  delayNextTapMilliseconds: 1000,
                  value: info.speed,
                ),
                ControlButton(
                  imageAssetPath: 'assets/images/buttons/armor.png',
                  onTap: armorButtonClicked,
                  delayNextTapMilliseconds: 2000,
                  value: info.armor,
                ),
                const Spacer(),
                ControlButton(
                  imageAssetPath: 'assets/images/buttons/fire.png',
                  onTap: fireButtonClicked,
                  delayNextTapMilliseconds: 500,
                  value: info.rocket,
                ),
                ControlButton(
                  imageAssetPath: 'assets/images/buttons/bomb.png',
                  onTap: bombButtonClicked,
                  delayNextTapMilliseconds: 4000,
                  value: info.bomb,
                ),
                const Spacer(),
              ],
            ),
          );
        });
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
