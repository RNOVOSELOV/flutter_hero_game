import 'package:flame/components.dart';
import 'package:flame_bloc/flame_bloc.dart';
import 'package:spacehero/entities/player.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/presentation/game_page/bloc/space_game_bloc.dart';

class PlayerController extends Component
    with
        HasGameRef<SpaceGame>,
        FlameBlocListenable<SpaceGameBloc, SpaceGameState>,
        FlameBlocReader<SpaceGameBloc, SpaceGameState> {
  @override
  Future<void> onLoad() {
    final value = super.onLoad();
    gameRef.joystick.priority = 10;
    gameRef.joystick.scale = Vector2(0, 0);
    parent?.add(gameRef.joystick);
    return value;
  }

  @override
  bool listenWhen(SpaceGameState previousState, SpaceGameState newState) {
    return newState is SpaceGameStatusChanged;
  }

  @override
  void onNewState(SpaceGameState state) {
    if (state is SpaceGameStatusChanged) {
      if (state.status == GameStatus.respawn) {
        gameRef.joystick.scale = Vector2(1, 1);
        if (gameRef.player != null) {
          gameRef.player!.removeFromParent();
          gameRef.player = null;
        }
        parent?.add(gameRef.player = Player(gameplayArea: gameRef.size));
      } else if (state.status == GameStatus.respawned) {
        if (gameRef.player != null) {
          gameRef.player!.respawnModeEnd();
        }
      } else {
        gameRef.joystick.scale = Vector2(0, 0);
      }
    }
  }
}
