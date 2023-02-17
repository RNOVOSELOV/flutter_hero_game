import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spacehero/game_core/main_loop.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]).whenComplete(() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
    runApp(const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Center(
        child: Text("Game"),
      ),
    ));
  });
}
