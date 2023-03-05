import 'dart:math';

import 'package:flame/components.dart';
import 'package:spacehero/entities/black_hole.dart';
import 'package:spacehero/presentation/space_game/space_game.dart';

// Timer.periodic(
// const Duration(seconds: 15),
// (_) => blackHoleManager(),
// );

class BlackHoleController extends TimerComponent with HasGameRef<SpaceGame> {
  static const double _blackHoleGenerationTimeInSeconds = 8;
  final _random = Random(DateTime.now().microsecond);
  BlackHole? blackHole;

  BlackHoleController()
      : super(period: _blackHoleGenerationTimeInSeconds, repeat: true);

  @override
  void onTick() {
    print('Black hole timer ticked!');
    if (blackHole == null) {
    } else {}
  }
}

/*
  FutureOr<void> blackHoleManager() async {
    bool blackHoleIsPresent = false;
    for (Entity entity in entities) {
      if (entity is BlackHole) {
        blackHoleIsPresent = true;
        entity.removeEntity();
        _maxAsteroidCount--;
      }
    }
    if (!blackHoleIsPresent) {
      _maxAsteroidCount++;
      Entity blackHole = BlackHole(
        screenWidth: _screenWidth,
        screenHeight: _screenHeight,
      );
      entities.add(blackHole);
      await add(blackHole);
    }
  }
 */
