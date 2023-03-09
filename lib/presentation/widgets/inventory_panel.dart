import 'package:animated_widgets/widgets/shake_animated_widget.dart';
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

  bool _addedSpeed = false;
  bool _addedArmor = false;
  bool _addedRockets = false;
  bool _addedBombs = false;

  Future<void> futureSpeed = Future<void>(() {});
  Future<void> futureArmor = Future<void>(() {});
  Future<void> futureRockets = Future<void>(() {});
  Future<void> futureBomb = Future<void>(() {});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SpaceGameBloc, SpaceGameState>(
      listenWhen: (previous, current) => current is InventChangedState,
      listener: (context, state) {
        if (state is InventChangedState) {
          _addedSpeed = false;
          _addedArmor = false;
          _addedRockets = false;
          _addedBombs = false;
          if (state.invent.bomb > inventDto.bomb) {
            _addedBombs = true;
            futureBomb = Future.delayed(const Duration(seconds: 4))
                .then((_) => setState(() => _addedBombs = false));
          }
          if (state.invent.speed > inventDto.speed) {
            _addedSpeed = true;
            futureSpeed = Future.delayed(const Duration(seconds: 4))
                .then((_) => setState(() => _addedSpeed = false));
          }
          if (state.invent.rocket > inventDto.rocket) {
            _addedRockets = true;
            futureRockets = Future.delayed(const Duration(seconds: 4))
                .then((_) => setState(() => _addedRockets = false));
          }
          if (state.invent.armor > inventDto.armor) {
            _addedArmor = true;
            futureArmor = Future.delayed(const Duration(seconds: 4))
                .then((_) => setState(() => _addedArmor = false));
          }
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
              isAnimationActive: _addedSpeed,
            ),
            ControlButton(
              imageAssetPath: 'assets/images/buttons/armor.png',
              onTap: armorButtonClicked,
              delayNextTapMilliseconds: 250,
              value: inventDto.armor,
              isAnimationActive: _addedArmor,
            ),
            const Spacer(),
            ControlButton(
              imageAssetPath: 'assets/images/buttons/fire.png',
              onTap: fireButtonClicked,
              delayNextTapMilliseconds: 250,
              value: inventDto.rocket,
              isAnimationActive: _addedRockets,
            ),
            ControlButton(
              imageAssetPath: 'assets/images/buttons/multi_fire.png',
              onTap: multiFireButtonClicked,
              delayNextTapMilliseconds: 250,
              value: inventDto.rocket,
              isAnimationActive: _addedRockets,
            ),
            ControlButton(
              imageAssetPath: 'assets/images/buttons/bomb.png',
              onTap: bombButtonClicked,
              delayNextTapMilliseconds: 4000,
              value: inventDto.bomb,
              isAnimationActive: _addedBombs,
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
    context.read<SpaceGameBloc>().add(const PlayerBombFireEvent());
  }

  @override
  void dispose() {
    futureSpeed.ignore();
    futureArmor.ignore();
    futureRockets.ignore();
    futureBomb.ignore();
    super.dispose();
  }
}
