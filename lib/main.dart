import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:spacehero/game_core/game.dart';

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
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.dark),
      home: const Game(),
    );
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);
  return baseTheme.copyWith(
    textTheme: GoogleFonts.pressStart2pTextTheme(baseTheme.textTheme),
  );
}
