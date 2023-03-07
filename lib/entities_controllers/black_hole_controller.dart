import 'package:flame/components.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/presentation/flame_space_game/space_game.dart';
import 'package:spacehero/resources/app_constants_parameters.dart';

class BlackHoleController extends TimerComponent with HasGameRef<SpaceGame> {
  BlackHole? blackHole;

  BlackHoleController()
      : super(
            period: AppConstants.blackHoleGenerationTimeInSeconds,
            repeat: true);

  @override
  void onTick() {
    if (blackHole != null) {
      blackHole!.removeEntity();
      blackHole = null;
    } else {
      blackHole = BlackHole(gameplayArea: gameRef.size);
      parent?.add(blackHole!);
    }
  }
}
