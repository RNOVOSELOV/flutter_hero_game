import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:spacehero/game_core/game_bloc.dart';
import 'package:spacehero/presentation/game_screen.dart';
import 'package:spacehero/resources/app_images.dart';

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
    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.dark),
      home: const SafeArea(
        child: Scaffold(body: GameScreen()),
      ),
    ));

/*    runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(Brightness.dark),
      home: const SafeArea(
        child: Scaffold(
          body: MyApp(),
        ),
      ),
    )); */
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GameBloc bloc;

  @override
  void initState() {
    super.initState();
    bloc = GameBloc();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      bloc.initBloc(width: screenWidth, height: screenHeight);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Provider.value(
      value: bloc,
      child: Container(
          decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(AppImages.backgroundImage),
                  fit: BoxFit.cover)),
          child: const SizedBox.shrink()), //const Game()),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}

ThemeData _buildTheme(brightness) {
  var baseTheme = ThemeData(brightness: brightness);
  return baseTheme.copyWith(
    textTheme: GoogleFonts.pressStart2pTextTheme(baseTheme.textTheme),
  );
}
