import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/presentation/space_game/bloc/space_game_bloc.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';

class PlayerController extends Component
    with
        HasGameRef<SpaceGame>,
        FlameBlocListenable<SpaceGameBloc, SpaceGameState> {
  @override
  bool listenWhen(SpaceGameState previousState, SpaceGameState newState) {
    return newState is SpaceGameStatusChanged;
  }

  @override
  void onNewState(SpaceGameState state) {
    if (state is SpaceGameStatusChanged) {
      if (state.status == GameStatus.initial ||
          state.status == GameStatus.respawn) {
//        gameRef.statsBloc.add(const PlayerRespawned());
        parent?.add(gameRef.player = Player(gameplayArea: gameRef.size));
      }
    }
  }
}
